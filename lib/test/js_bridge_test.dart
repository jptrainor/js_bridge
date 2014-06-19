// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library js_bridge_test;

import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:js_bridge/js_bridge.dart' as jsb;

import 'package:unittest/unittest.dart';

part 'js_data_mapping_test.dart';

Future _insertJsScript(String src) {
  var script = new html.ScriptElement();
  script.type = "text/javascript";
  script.src = src;

  var loadCompleter = new Completer();
  script.onLoad.listen((html.Event event) {
    loadCompleter.complete();
  });

  html.document.body.nodes.add(script);

  return loadCompleter.future;
}


bool _loaded = false;
_loadJs() {
  if (_loaded) {
    return new Future.value();
  }

  _loaded = true;
  var scriptSrc = "packages/js_bridge/js_bridge.js";
  var scriptTest = "packages/js_bridge/test/js_bridge_test.js";
  return _insertJsScript(scriptSrc).then((_) => _insertJsScript(scriptTest));
}

class _JsTestTarget {

  bool _forceError;

  _JsTestTarget(this._forceError);

  var lastArg1_1;

  dynamic testTarget1(var arg1) {
    if (_forceError) {
      throw "testTarget1";
    }

    lastArg1_1 = arg1;
    return arg1;
  }

  var lastArg2_1;
  var lastArg2_2;

  dynamic testTarget2(var arg1, var arg2) {
    if (_forceError) {
      throw "testTarget2";
    }

    lastArg2_1 = arg1;
    lastArg2_2 = arg2;
    return [arg1, arg2];
  }

  var lastArg3_1;
  var lastArg3_2;
  var lastArg3_3;

  dynamic testTarget3(var arg1, var arg2, var arg3) {
    if (_forceError) {
      throw "testTarget3";
    }

    lastArg3_1 = arg1;
    lastArg3_2 = arg2;
    lastArg3_3 = arg3;
    return [arg1, arg2, arg3];
  }


  Future<bool> testTarget4AsyncError;

  /**
   * This test target verifies operation of error zone handling by
   * throwing an exception asynchrounously after the target has returned
   * from the javascript call.
   */
  dynamic testTarget4() {

    var completer = new Completer<bool>();

    testTarget4AsyncError = completer.future;

    handleTimeout() {
      completer.complete(true);
      throw "testTarget4-async-error";
    }

    new Timer(new Duration(seconds: 1), handleTimeout);

    return "testTarget4-result";
  }

  dynamic testTarget5(String arg1, jsb.JsCallback callback) {
    return callback(arg1);
  }

  dynamic testTarget6(String arg1, num arg2, jsb.JsCallback callback) {
    return callback([arg1, arg2]);
  }

}

_bridge_test() {

  // create the bridge and register a target calls
  var jsBridge = new jsb.JsBridge("bridge_test");
  var jsTestTarget = new _JsTestTarget(false);

  var testTargetName1 = "testTarget1";
  var testTargetName2 = "testTarget2";
  var testTargetName3 = "testTarget3";

  jsBridge.registerHandler1(testTargetName1, jsTestTarget.testTarget1);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isFalse);

  jsBridge.registerHandler2(testTargetName2, jsTestTarget.testTarget2);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isFalse);

  jsBridge.registerHandler3(testTargetName3, jsTestTarget.testTarget3);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isTrue);

  // execute the java script call which will call back with known arguments
  js.context.callMethod("jsBridgeTest");
  var expectedArg1_1 = [1, "2", 3.3, ["a", "b"], {
      "c": "d"
    }];
  var expectedArg2_1 = [1, "2", 3.3, ["a", "b"]];
  var expectedArg2_2 = [1, "2", 3.3];

  // TODO - replace the string compare with a proper deep equality test.

  // verify the results that were passed back to java by the test targers (this indirectly
  // validates the arguments that were passed from javascript to dart correctly).
  expect(expectedArg1_1.toString(), jsb.js2dart(js.context['bridge_test_result_1']).toString());
  expect([expectedArg2_1, expectedArg2_2].toString(), jsb.js2dart(js.context['bridge_test_result_2']).toString());
  expect([1, '2', 3.3].toString(), jsb.js2dart(js.context['bridge_test_result_3']).toString());

  // verify deregister call
  jsBridge.deregisterHandler(testTargetName1);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isTrue);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isTrue);

  jsBridge.deregisterHandler(testTargetName2);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isTrue);

  jsBridge.deregisterHandler(testTargetName3);
  expect(jsBridge.isRegisteredHandler(testTargetName1), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName2), isFalse);
  expect(jsBridge.isRegisteredHandler(testTargetName3), isFalse);
}

_bridge_callback_test() {

  // create the bridge and register a target calls
  var jsBridge = new jsb.JsBridge("bridge_calback_test");
  var jsTestTarget = new _JsTestTarget(false);

  var testTargetName5 = "testTarget5";
  var testTargetName6 = "testTarget6";

  jsBridge.registerHandler2(testTargetName5, jsTestTarget.testTarget5);
  jsBridge.registerHandler3(testTargetName6, jsTestTarget.testTarget6);

  String arg1 = "1";
  num arg2 = 2;

  js.context.callMethod("jsBridgeCallbackTest", [arg1, arg2]);

  expect(arg1, equals(js.context['bridge_callback_test_result_1_1']));
  expect(arg1, equals(js.context['bridge_callback_test_result_2_1']));
  expect(arg2, equals(js.context['bridge_callback_test_result_2_2']));
}

_bridge_error_test() {

  var errors = new Set();

  errorHandler(e) => errors.add(e);

  var jsBridge = new jsb.JsBridge("bridge_error_test", errorHandler);
  var jsTestTarget = new _JsTestTarget(true);

  var testTargetName1 = "testTarget1";
  var testTargetName2 = "testTarget2";
  var testTargetName3 = "testTarget3";
  var testTargetName4 = "testTarget4";

  jsBridge.registerHandler1(testTargetName1, jsTestTarget.testTarget1);
  jsBridge.registerHandler2(testTargetName2, jsTestTarget.testTarget2);
  jsBridge.registerHandler3(testTargetName3, jsTestTarget.testTarget3);
  jsBridge.registerHandler0(testTargetName4, jsTestTarget.testTarget4);

  // Verify expected before error result values.
  expect(js.context['bridge_error_test_result_1'], equals('no-result'));
  expect(js.context['bridge_error_test_result_2'], equals('no-result'));
  expect(js.context['bridge_error_test_result_3'], equals('no-result'));
  expect(js.context['bridge_error_test_result_4'], equals('no-result'));

  js.context.callMethod("jsBridgeErrorTest");

  expect(errors, contains("testTarget1"));
  expect(errors, contains("testTarget2"));
  expect(errors, contains("testTarget3"));

  // Verify expected after error result values. Note, that the true value
  // is not documented as the return value for a js call that does not
  // return due to an exception - it just appears to be what happens
  // when the call is interupted by an exception.
  expect(js.context['bridge_error_test_result_1'], isTrue);
  expect(js.context['bridge_error_test_result_2'], isTrue);
  expect(js.context['bridge_error_test_result_3'], isTrue);
  expect(js.context['bridge_error_test_result_4'], "testTarget4-result");

  expect(errors.length, equals(3));

  verifyTarget4(_) {
    expect(errors, contains("testTarget4-async-error"));
    expect(errors.length, equals(4));
    return new Future.value();
  }

  // Verify async error handling by waiting for the async error to be handled.
  // The error handler should be called because the bridged javascript->dart call
  // is executed in an error zone.
  return jsTestTarget.testTarget4AsyncError.then(verifyTarget4);
}

/**
 * Expose js_bridge tests for execution from arbitrary entry points.
 *
 * Call this from whereever your test entry point happens to be. For example,
 * the js_bridge package includes a test entry point that simple
 * executes the js_bridge tests that are setup by this call.
 * Testing is performed this way because js_bridge package is used as part of large
 * system where many packages are tested from a single, top-level, entry point. Placing
 * the tests in the lib directory in this way makes them available from multiple entry
 * points. No test code will make its way into a client application unless that
 * application imports the js_bridge_test library and, even then, unless they call
 * setupTests() (because of tree shaking).
 */
setupTests() {
  setUp(_loadJs);

  test("js to dart mapping", _jsDataMappingTest);

  test("dart to js mapping", _dartDataMappingTest);

  test("javascript bridge", _bridge_test);

  test("javascript bridge callback", _bridge_callback_test);

  test("javascript bridge zone error", _bridge_error_test);
}
