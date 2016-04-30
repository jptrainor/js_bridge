// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of js_bridge;

js.JsObject _jsObject = js.context['Object'];

/**
 * Deep conversion of a js.JsObject to a dart Map<String,Object>.
 */
Map<String, Object> js2map(js.JsObject object) {
  if (object == null) {
    return null;
  }
  var result = new Map<String,Object>();
  for(var key in _jsObject.callMethod('keys',[object])) {
    result[key as String] = js2dart(object[key]);
  }
  return result;
}

/**
 * Deep conversion of a js.JsArray to a dart List<Object>.
 */
List<Object> js2list(js.JsArray array) {
  if (array == null) {
    return null;
  }
  var result = new List<Object>(array.length);
  for(int i = 0; i < array.length; i++) {
    result[i] = js2dart(array[i]);
  }
  return result;
}

/**
 * Map javascript object to a dart object. Specifically, check if the type is
 * JsArray or JsObject and map to List<Object> or Map<String,Object>. Other types
 * are returned untouched. The mapping is performed recursively.
 */
dynamic js2dart(var jsobj) {
  if (jsobj is js.JsArray) {
    return js2list(jsobj as js.JsArray);
  }
  else if (jsobj is js.JsFunction) {
    return new JsCallback(jsobj);
  }
  else if (jsobj is js.JsObject) {
    return js2map(jsobj as js.JsObject);
  }
  else {
    return jsobj;
  }
}
