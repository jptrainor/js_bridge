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

part of js_bridge_test;

js.JsFunction jsFunction = new js.JsFunction.withThis((jsThis,args){});

Map<String, Object> _mappingTestData =
{
 'a' : 1,
 'b' : 'b',
 'c' : [2, 'x'],
 'd' : {'m' : 3, 'n' : 'n', 'o' : {'q' : 4}, 'v' : [5,6,7]},
 'e' : [1, 'b', {'c' : 'd'}],
};

jsDataMappingTest() {

  js.JsObject testJsDataAsJsObject = new js.JsObject.jsify(_mappingTestData);

  Map<String, Object> testJsDataRoundTrip = jsb.js2dart(testJsDataAsJsObject);

  // TODO - this is cheap string conversion used as a deep equality test.
  // There is a need for a better way to perform deep equality.
  expect(_mappingTestData.toString(), equals(testJsDataRoundTrip.toString()));

  // verify callback function mapping
  expect(jsb.js2dart(jsFunction), new isInstanceOf<jsb.JsCallback>());
}

dartDataMappingTest() {
  expect(jsb.dart2js(_mappingTestData) is js.JsObject, isTrue);
  expect(jsb.dart2js("string") is String, isTrue);

  // TODO - another deep equality test using string conversion/compare.
  expect(jsb.js2dart(jsb.dart2js(_mappingTestData)).toString(), equals(_mappingTestData.toString()));

  expect(jsb.dart2js("string"), equals("string"));
}