// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

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