# js_bridge

Dart provides good integration between Javascript and Dart if your goal is to original Javascript calls from Dart. If you want to the reverse - original Dart calls from Javascript then Dart's native Javascript integration is not so seamless. That's where js_bridge comes in. It provides a simple means of registering Dart functions that can be call like ordinary Javascript functions from your Javascript.

There is not much documentation yet, but it is very simple to use. Your best best is to use the tests as an example. Start by looking at test/js_bridge_test.dart.

## Performance

There is a performance test included with the js_bridge unit tests. It measures the time required to complete a single function call with an integer argument return value from Dart to Javascript, and from Javascript to Dart. This test measures the performance _without_ the overhead of the js_bridge layer. A single function in either direction is about 2 µs. Consider this a baseline performance expectation.

Below are the performance test results running an 2.8 GHz i5, and Dart 1.4.2 and the bundled Dartium, and dart2js generated Javascript running in Chrome 35.0.1916.114.

Dartium (VM):

    javascript call to dart = 1414 ns/call
    dart call to javascript = 2238 ns/call

Chrome (dart2js):

    javascript call to dart = 2303 ns/call
    dart call to javascript = 1442 ns/call

## Does it really work? Is it actually useful?

Yes. It is used in a real life project to put an ExtJS interface on top of a layer of Dart code that is responsible for all server communication, resource caching, etc. It works fine in this application.







