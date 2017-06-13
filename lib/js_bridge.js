// Copyright (c) 2014-2017, Jim Trainor. All rights reserved. Use of this js_bridge
// source code is governed by a BSD-style license that can be found in the LICENSE file.

/**
This is the javascript half of the Dart js_bridge package. The Dart JsBridge class
registers JS_BRIDGE Namespace instances and registers Dart function handlers in those
namespaces. Javascript application code must lookup the namespace by name and can then
use the namespace object to call Dart functions registered in that namespace.

// Lookup a namespace that is known to have been registered.
var myDartNamespace = JS_BRIDGE.lookupNamespace("myDartNamespace");

// Call a registered Dart function by name. You have to get the
// length of the argument list correct or else the Dart code will
// throw an exception.
myDartNamespace.callHandler("myDartFunction", [arg1, arg2]);

// or call the named function directly using dot notation
myDartNamespace.myDartFunction(arg1, args);
*/

/*jslint browser: true, stupid: true */

/*global JS_BRIDGE : true */

/*properties
    apply, Namespace, namespaceName, namespaces, handlers, handlerNames, isRegisteredHandler,
    getRegisteredHandlerNames, registerHandler, deregisterHandler, getHandler, callHandler,
    push, prototype, lookupNamespace, registerNamespace, readyListeners, notifyReady, addReadyListener,
    ready, length
*/

if (!JS_BRIDGE) {
    var JS_BRIDGE = {};
}

(function () {
    'use strict';

    var jsb = JS_BRIDGE;

    jsb.namespaces = {};
    jsb.readyListeners = {};

    // Notify all namespace ready listeners.
    jsb.notifyReady = function (namespaceName) {
        var i,
            listeners = jsb.readyListeners[namespaceName],
            namespace = jsb.lookupNamespace(namespaceName);
        if (listeners && namespace && namespace.ready) {
            for (i = 0; i < listeners.length; i = i + 1) {
                listeners[i](namespace);
            }
        }
    };

    // Add a callback that is called when the namespace is registered.
    // If the namespace is ready then ready listeners are called immediately.
    jsb.addReadyListener = function (namespaceName, listener) {
        if (!jsb.readyListeners[namespaceName]) {
            jsb.readyListeners[namespaceName] = [];
        }
        jsb.readyListeners[namespaceName].push(listener);
        jsb.notifyReady(namespaceName);
    };

    // Lookup and instance of jsb.Namespace by name.
    jsb.lookupNamespace = function (namespaceName) {
        return jsb.namespaces[namespaceName];
    };

    // Register an instance of jsb.Namespace.
    jsb.registerNamespace = function (namespace) {
        jsb.namespaces[namespace.namespaceName] = namespace;
    };

    // Create a js_bridge Namespace.
    jsb.Namespace = function Namespace(namespaceName) {
        this.namespaceName = namespaceName;
        this.ready = false;
        this.handlerNames = [];
    };

    jsb.Namespace.prototype.notifyReady = function () {
        this.ready = true;
        jsb.notifyReady(this.namespaceName);
    };

    // Get the list of handler names registered with this namespace.
    jsb.Namespace.prototype.getRegisteredHandlerNames = function () {
        return this.handlerNames;
    };

    // Register a function handler with this namespace. This is called by
    // the Dart JsBridge class to expose a Dart function.
    jsb.Namespace.prototype.registerHandler = function (name, handler) {
        this.handlerNames.push(name);
        this[name] = handler;
    };

    // Deregister a function handler by name.
    jsb.Namespace.prototype.deregisterHandler = function (name) {
        delete this[name];
        delete jsb.namespaces[name];
        delete jsb.readyListeners[name];
    };

    // Return true if the named function handler is registered.
    jsb.Namespace.prototype.isRegisteredHandler = function (name) {
        return this[name] !== undefined;
    };

    // Return the named function handler.
    jsb.Namespace.prototype.getHandler = function (name) {
        return this[name];
    };

    // Call the a function handler by name. This is one way for the
    // Javascript application to call handler.
    jsb.Namespace.prototype.callHandler = function (name, args) {
        return this[name].apply(this, args);
    };
}());
