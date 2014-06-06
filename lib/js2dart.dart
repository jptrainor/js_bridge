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
 * Deep conversion a js.JsArray to a dart List<Object>.
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
