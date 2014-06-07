part of js_bridge;

/**
 * Wraps a [js.JsFunction] received from a javascript call.
 *
 * Simple wrapper around a js.JsFunction that makes it easier to execute a
 * javascript callback (passed to a bridged function) from dart.
 */
class JsCallback {
  js.JsFunction _jsFunctionToCall;

  JsCallback(this._jsFunctionToCall);

  /**
   * Call the javascript callback with specified arguments. If arg is a list then
   * each entry in the list is converted from dart to js form and the list is applied
   * to the javascript callback. If args is not a list then it converted to javascript
   * form and added as the single entry in a list which is then applied to the callback
   * function.
   */
  void call(var args) {
    var jsArgs = [];

    if (args is List) {
      for (var arg in args) {
        jsArgs.add(dart2js(arg));
      }
    }
    else {
      jsArgs.add(dart2js(args));
    }

    _jsFunctionToCall.apply(jsArgs);
  }
}
