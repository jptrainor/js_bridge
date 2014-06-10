// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/*jslint browser: true, stupid: true */

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
