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

/*global JS_BRIDGE : true */

/*properties
    Context, callDart, contextName, contexts, handlers, isRegisteredHandler,
    prototype, lookupContext, registerContext, registerHandler, getHandler
*/

if (!JS_BRIDGE) {
    var JS_BRIDGE = {};
}

(function () {
    "use strict";

    var jsb = JS_BRIDGE;

    jsb.contexts = {};

    jsb.lookupContext = function (contextName) {
        return jsb.contexts[contextName];
    };

    jsb.registerContext = function (context) {
        jsb.contexts[context.contextName] = context;
    };

    jsb.Context = function Context(contextName) {
        this.contextName = contextName;
        this.handlerNames = [];
    };

    jsb.Context.prototype.getRegisteredHandlerNames = function () {
        return this.handlerNames;
    };

    jsb.Context.prototype.registerHandler = function (name, handler) {
        this.handlerNames.push(name);
        this[name] = handler;
    };

    jsb.Context.prototype.deregisterHandler = function (name) {
        delete this[name];
    };

    jsb.Context.prototype.isRegisteredHandler = function (name) {
        return this[name] !== undefined;
    };

    jsb.Context.prototype.getHandler = function (name) {
        return this[name];
    };

    jsb.Context.prototype.callHandler = function (name, args) {
        this[name].apply(this, args);
    };
}());