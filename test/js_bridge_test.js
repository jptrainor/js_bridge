/*jslint browser: true, stupid: true */

/*global JS_BRIDGE : true */

var bridge_test_result_1 = "no-result";
var bridge_test_result_2 = "no-result";
var bridge_test_result_3 = "no-result";
var bridge_test_result_4 = "no-result";

function jsBridgeTest() {
    "use strict";

    var bridge_test = new JS_BRIDGE.lookupNamespace("bridge_test"),
        arg1_1 = [1, "2", 3.3, ["a", "b"], {"c": "d"}],
        arg2_1 = [1, "2", 3.3, ["a", "b"]],
        arg2_2 = [1, "2", 3.3];

    bridge_test_result_1 = bridge_test.testTarget1(arg1_1);
    bridge_test_result_2 = bridge_test.testTarget2(arg2_1, arg2_2);
    bridge_test_result_3 = bridge_test.testTarget3(1, '2', 3.3);
}


var bridge_callback_test_result_1_1 = "no-result";
var bridge_callback_test_result_2_1 = "no-result";
var bridge_callback_test_result_2_2 = "no-result";

function jsBridgeCallbackTest(arg1, arg2) {
    "use strict";

    var bridge_calback_test = new JS_BRIDGE.lookupNamespace("bridge_calback_test"),
        cbA = function (arg1) {
            bridge_callback_test_result_1_1 = arg1;
        },
        cbB = function (arg1, arg2) {
            bridge_callback_test_result_2_1 = arg1;
            bridge_callback_test_result_2_2 = arg2;
        };

    bridge_calback_test.testTarget5(arg1, cbA);
    bridge_calback_test.testTarget6(arg1, arg2, cbB);
}

var bridge_error_test_result_1 = "no-result";
var bridge_error_test_result_2 = "no-result";
var bridge_error_test_result_3 = "no-result";
var bridge_error_test_result_4 = "no-result";

function jsBridgeErrorTest() {
    "use strict";

    var bridge_error_test = new JS_BRIDGE.lookupNamespace("bridge_error_test"),
        arg1_1 = [1, "2", 3.3, ["a", "b"], {"c": "d"}],
        arg2_1 = [1, "2", 3.3, ["a", "b"]],
        arg2_2 = [1, "2", 3.3];

    bridge_error_test_result_1 = bridge_error_test.testTarget1(arg1_1);
    bridge_error_test_result_2 = bridge_error_test.testTarget2(arg2_1, arg2_2);
    bridge_error_test_result_3 = bridge_error_test.testTarget3(1, '2', 3.3);

    // and, finally, the async error case
    bridge_error_test_result_4 = bridge_error_test.testTarget4();
}