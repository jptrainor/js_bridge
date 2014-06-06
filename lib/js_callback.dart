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

part of js_bridge;

/**
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
