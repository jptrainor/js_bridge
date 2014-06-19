// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library js_bridge_test;

import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:js_bridge/test/js_bridge_test.dart' as jsb_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'perf_test.dart';

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

bool loaded = false;
makeLoadJs(String scriptPath) {
  return () {
    if (loaded) {
      return new Future.value();
    }

    loaded = true;
    var scriptSrc = "packages/js_bridge/js_bridge.js";
    var scriptTest = "${scriptPath}/js_bridge_test.js";
    return insertJsScript(scriptSrc).then((_) => insertJsScript(scriptTest));
  };
}

main() {
  useHtmlConfiguration();
  jsb_test.setupTests("../lib/test");
  setupPerfTest();
}
