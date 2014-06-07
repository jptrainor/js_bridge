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