// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

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
 * Expose dart functions to javascript callers.
 *
 * Registration class for dart functions that are accessible from javascript. A JsBridge
 * instance is a namespace for a collection of registered dart functions. All incoming
 * (from javascript) arguments are mapped to dart values. Primitive types (string, int,
 * double), arrays, and maps (javascript objects) map by passed as arguments. The return
 * value is mapped to a javascript primitive, array, or map. All calls registered with
 * a single [JsBridge] instance are executed in a shared error zone.
 */
class JsBridge {

  String _namespace;
  Function _onZoneError;

  js.JsObject _jsContext;

  /**
   * Create a JsBridge with the specified name name space. Optionally provide an
   * [onZoneError] function to use as the [runZoned] error handler for all registered
   * call handlers.
   */
  JsBridge(this._namespace, [Function onZoneError = print]) {
    _jsContext = new js.JsObject(js.context['JS_BRIDGE']['Namespace'], [_namespace]);
    _onZoneError = onZoneError;
    js.context['JS_BRIDGE'].callMethod('registerNamespace', [_jsContext]);
  }

  /**
   * Notify listeners that the bridge is ready. Note that listeners are registered
   * by the javascript code using the JS_BRIDGE.addRegistrationListener function.
   * Ready listeners added after this notifyReady() call are notifed at the moment
   * they are added.
   */
  void notifyReady() => _jsContext.callMethod('notifyReady');
  
  dynamic _zoned(body()) {
    return runZoned(body, onError: _onZoneError);
  }

  /**
   * Register a [handler] that takes no arguments as [name].
   */
  void registerHandler0(String name, Function0 handler) {
    makeMapper(Function0 f) => () => _zoned(()=>_d(f()));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes one argument as [name].
   */
  void registerHandler1(String name, Function1 handler) {
    makeMapper(Function1 f) => (a1) => _zoned(()=>_d(f(_j(a1))));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes two arguments as [name].
   */
  void registerHandler2(String name, Function2 handler) {
    makeMapper(Function2 f) => (a1, a2) => _zoned(()=>_d(f(_j(a1), _j(a2))));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes three arguments as [name].
   */
  void registerHandler3(String name, Function3 handler) {
    makeMapper(Function3 f) => (a1, a2, a3) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3))));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes four arguments as [name].
   */
  void registerHandler4(String name, Function4 handler) {
    makeMapper(Function4 f) => (a1, a2, a3, a4) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4))));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes five arguments as [name].
   */
  void registerHandler5(String name, Function5 handler) {
    makeMapper(Function5 f) => (a1, a2, a3, a4, a5) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4), _j(a5))));
    _register(name, makeMapper(handler));
  }

  /**
   * Register a [handler] that takes six arguments as [name].
   */
  void registerHandler6(String name, Function6 handler) {
    makeMapper(Function6 f) => (a1, a2, a3, a4, a5, a6) => _zoned(()=>_d(f(_j(a1), _j(a2), _j(a3), _j(a4), _j(a5), _j(a6))));
    _register(name, makeMapper(handler));
  }

  void _register(name, Function handler) => _jsContext.callMethod('registerHandler', [name, handler]);

  /**
   * Deregister a handler by [name].
   */
  void deregisterHandler(String name) {
    _jsContext.callMethod('deregisterHandler', [name]);
  }

  /**
   * Return true if a handler with [name] is registered.
   */
  bool isRegisteredHandler(String name) {
    return _jsContext.callMethod('isRegisteredHandler', [name]);
  }
}
