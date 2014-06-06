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

var bridge_test_result_1 = "no-result";
var bridge_test_result_2 = "no-result";
var bridge_test_result_3 = "no-result";
var bridge_test_result_4 = "no-result";

function jsBridgeTest() {
    var context = new JS_BRIDGE.lookupContext("bridge_test");

    var arg1_1 = [1, "2", 3.3, ["a", "b"], {"c": "d"}];
    var arg2_1 = [1, "2", 3.3, ["a", "b"]];
    var arg2_2 = [1, "2", 3.3];

    bridge_test_result_1 = context.testTarget1(arg1_1);
    bridge_test_result_2 = context.testTarget2(arg2_1, arg2_2);
    bridge_test_result_3 = context.testTarget3(1, '2', 3.3);
}


var bridge_callback_test_result_1_1 = "no-result";
var bridge_callback_test_result_2_1 = "no-result";
var bridge_callback_test_result_2_2 = "no-result";

function jsBridgeCallbackTest(arg1, arg2) {
    var context = new JS_BRIDGE.lookupContext("bridge_calback_test");

    var cbA = function(arg1) {
      bridge_callback_test_result_1_1 = arg1;
    }

    var cbB = function(arg1, arg2) {
      bridge_callback_test_result_2_1 = arg1;
      bridge_callback_test_result_2_2 = arg2;
    }

    context.testTarget5(arg1, cbA);
    context.testTarget6(arg1, arg2, cbB);
}

var bridge_error_test_result_1 = "no-result";
var bridge_error_test_result_2 = "no-result";
var bridge_error_test_result_3 = "no-result";
var bridge_error_test_result_4 = "no-result";

function jsBridgeErrorTest() {
    var context = new JS_BRIDGE.lookupContext("bridge_error_test");

    var arg1_1 = [1, "2", 3.3, ["a", "b"], {"c": "d"}];
    var arg2_1 = [1, "2", 3.3, ["a", "b"]];
    var arg2_2 = [1, "2", 3.3];

    bridge_error_test_result_1 = context.testTarget1(arg1_1);
    bridge_error_test_result_2 = context.testTarget2(arg2_1, arg2_2);
    bridge_error_test_result_3 = context.testTarget3(1, '2', 3.3);

    // and, finally, the async error case
    bridge_error_test_result_4 = context.testTarget4();
}