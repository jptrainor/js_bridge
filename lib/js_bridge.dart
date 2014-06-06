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

library js_bridge;

import 'dart:js' as js;
import 'dart:async';

part 'js2dart.dart';
part 'dart2js.dart';
part 'js_callback.dart';

typedef dynamic Function0();
typedef dynamic Function1(var arg1);
typedef dynamic Function2(var arg1, var arg2);
typedef dynamic Function3(var arg1, var arg2, var arg3);
typedef dynamic Function4(var arg1, var arg2, var arg3, var arg4);
typedef dynamic Function5(var arg1, var arg2, var arg3, var arg4, var arg5);
typedef dynamic Function6(var arg1, var arg2, var arg3, var arg4, var arg5, var arg6);

_j(var arg) => js2dart(arg);
_d(var arg) => dart2js(arg);

/**
 * Registration class for dart functions that accessible from javascript. A JsBridge
 * instance is a namespace for a collection of registered calls. All incoming (from javascript)
 * arguments are mapped to dart values. Primitive types (string, int, doulble), arrays, and
 * maps (javascript objects) map by passed as arguments. The return value is mapped to a
 * javascript primitive, array, or map. The dart call is executed in an error zone.
 */
class JsBridge {

  String _contextName;
  Function _onZoneError;

  js.JsObject _jsContext;

  JsBridge(this._contextName, [this._onZoneError = print]) {
    _jsContext = new js.JsObject(js.context['JS_BRIDGE']['Context'], [_contextName]);
    js.context['JS_BRIDGE'].callMethod('registerContext', [_jsContext]);
  }

  dynamic _zoned(body()) {
    return runZoned(body, onError: _onZoneError);
  }

  void registerHandler0(String name, Function0 handler) {
    makeMapper(Function0 f) => () => _zoned(()=>_d(f()));
    _register(name, makeMapper(handler));
  }

  void registerHandler1(String name, Function1 handler) {
    makeMapper(Function1 f) => (a1) => _zoned(()=>_d(f(_j(a1))));
    _register(name, makeMapper(handler));
  }

  void registerHandler2(String name, Function2 handler) {
    makeMapper(Function2 f) => (a1, a2) => _zoned(()=>_d(f(_j(a1), _j(a2))));
    _register(name, makeMapper(handler));
  }

  void registerHandler3(String name, Function3 handler) {
    makeMapper(Function3 f) => (a1, a2, a3) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3))));
    _register(name, makeMapper(handler));
  }

  void registerHandler4(String name, Function4 handler) {
    makeMapper(Function4 f) => (a1, a2, a3, a4) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4))));
    _register(name, makeMapper(handler));
  }

  void registerHandler5(String name, Function5 handler) {
    makeMapper(Function5 f) => (a1, a2, a3, a4, a5) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4), _j(a5))));
    _register(name, makeMapper(handler));
  }

  void registerHandler6(String name, Function6 handler) {
    makeMapper(Function6 f) => (a1, a2, a3, a4, a5, a6) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4), _j(a5), _j(a6))));
    _register(name, makeMapper(handler));
  }

  void _register(name, Function handler) => _jsContext.callMethod('registerHandler', [name, handler]);

  void deregisterHandler(String name) {
    _jsContext.callMethod('deregisterHandler', [name]);
  }

  bool isRegisteredHandler(String name) {
    return _jsContext.callMethod('isRegisteredHandler', [name]);
  }
}