part of js_bridge_test;

Future runPerfTest(_) {
  const callCount = 1e6;

  dynamic recv(/*ReplyHandler replyHandler,*/ dynamic msg) {
    return msg;
  }

  var jsToDartCompleter = new Completer();

  jsToDartCompletionCallback(elapsedMilliSeconds) {
    var usPerCall = (1.0e6*elapsedMilliSeconds) ~/ callCount;
    print ("bare messaging performance, javascript call to dart = $usPerCall ns/call");
    jsToDartCompleter.complete();
  };

  js.JsObject perfTest = new js.JsObject(js.context['JsBridgePerfTest'], [recv, callCount, jsToDartCompletionCallback]);

  perfTest.callMethod('runJs2Dart');

  void dartToJsPerfTest(_) {

    var stopWatch = new Stopwatch()..start();
    for(int i = 0; i < callCount; i++) {
      var result = perfTest.callMethod('dart2Js', [i]);
      // don't want overhead of expect call in timed loop, just compare.
      if (result != i) {
        expect("unexpected dart2Js result", isFalse);
      }
    }
    stopWatch.stop();
    var perCall = 1000.0 * stopWatch.elapsedMicroseconds ~/ callCount;
    var units = "ns/call";

    print ("bare messaging performance, dart call to javascript = $perCall $units");
  };

  return jsToDartCompleter.future.then(dartToJsPerfTest);
}

Future perfTest() {
  var scriptSrc = "perf_test.js";
  return insertJsScript(scriptSrc).then(runPerfTest);
}