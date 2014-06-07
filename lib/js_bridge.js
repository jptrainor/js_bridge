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