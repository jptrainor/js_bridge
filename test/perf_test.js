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

/*jslint browser: true, stupid: true */

/*global ReceivePortSync */

function JsBridgePerfTest(dartRecvFunc, count, completionCallback) {
    "use strict";
    this.dartRecvFunc = dartRecvFunc;
    this.count = count;
    this.completionCallback = completionCallback;
}

(function () {
    "use strict";

    JsBridgePerfTest.prototype.runJs2Dart = function () {
        var i, result, start, stop;

        start = Date.now();
        for (i = 0; i < this.count; i += 1) {
            result = this.dartRecvFunc(i);
            if (result !== i) {
                throw "failed on bad result value " + result + " !== " + this.count;
            }
        }
        stop = Date.now();
        this.completionCallback(stop - start);
    };

    JsBridgePerfTest.prototype.dart2Js = function (msg) {
    	return msg;
    };
}());
