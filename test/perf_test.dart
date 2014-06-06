/*
Copyright 2014 Jim Trainor

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

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