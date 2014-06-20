// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of benchmark;

Future insertJsScript(String src) {
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

Future runPerfTest(_) {
  const callCount = 1e6;

  dynamic recv(/*ReplyHandler replyHandler,*/ dynamic msg) {
    return msg;
  }

  var jsToDartCompleter = new Completer();

  jsToDartCompletionCallback(elapsedMilliSeconds) {
    var usPerCall = (1.0e6 * elapsedMilliSeconds) ~/ callCount;
    print("bare messaging performance, javascript call to dart = $usPerCall ns/call");
    jsToDartCompleter.complete();
  }
  ;

  js.JsObject perfTest = new js.JsObject(js.context['JsBridgePerfTest'], [recv, callCount, jsToDartCompletionCallback]);

  perfTest.callMethod('runJs2Dart');

  void dartToJsPerfTest(_) {

    var stopWatch = new Stopwatch()..start();
    for (int i = 0; i < callCount; i++) {
      var result = perfTest.callMethod('dart2Js', [i]);
      // don't want overhead of expect call in timed loop, just compare.
      if (result != i) {
        expect("unexpected dart2Js result", isFalse);
      }
    }
    stopWatch.stop();
    var perCall = 1000.0 * stopWatch.elapsedMicroseconds ~/ callCount;
    var units = "ns/call";

    print("bare messaging performance, dart call to javascript = $perCall $units");
  }
  ;

  return jsToDartCompleter.future.then(dartToJsPerfTest);
}

setupPerfTest([String testDirPath = "."]) {
  test("js_bridge perf", () {
    var scriptSrc = "${testDirPath}/perf_test.js";
    return insertJsScript(scriptSrc).then(runPerfTest);
  });
}
