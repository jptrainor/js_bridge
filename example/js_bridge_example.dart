library js_bridge_example;

import 'package:js_bridge/js_bridge.dart' as jsb;
import 'dart:js' as js;

// A few examples of functions that are exposed to the Javascript
// side of the world.
List<Object> myFuncA(int x, String y) {
  return [x, y];
}

Map<String, Object> myFuncB(Map<String, Object> obj) {
  return obj;
}

List<Object> myFuncC(List<Object> list) {
  return list;
}

// A method on an object can be bridged and of course has
// access to the object's state.
class MyClass {
  int x;
  String y;

  MyClass(this.x, this.y);

  void myFuncD(int x, String y, jsb.JsCallback callback) {
    if (this.x != x || this.y != y)  {
        throw "unexpected argument values";
    }
    callback([x, y]);
  }
}

// It is safe to let unhandled exceptions escape. The call to
// the bridged function is wrapped inside an error zone that will
// handle the exception and forward it to a configured error
// handler.
myFuncE() {
  throw "something really bad happened";
}

// This is the error handler for the example bridge.
onJsBridgeError(msg) {
  print("An error occurred executing a bridged function: \"$msg\"");
}

main() {
  // We need a bridge and that defines a namespace name, in this case "example",
  // and provides an error handler.
  jsb.JsBridge exampleBridge = new jsb.JsBridge("example", onJsBridgeError);
  MyClass myObject = new MyClass(1, "two");

  exampleBridge.registerHandler2("myFuncA", myFuncA);
  exampleBridge.registerHandler1("myFuncB", myFuncB);
  exampleBridge.registerHandler1("myFuncC", myFuncC);
  exampleBridge.registerHandler3("myFuncD", myObject.myFuncD);
  exampleBridge.registerHandler0("myFuncE", myFuncE);

  // Notify javascript listeners that the bridge is ready for use.
  exampleBridge.notifyReady();
  
  // Note: there is no need to worry about the bridge disappearing and the
  // javascript calls failing after main() exits.
}
