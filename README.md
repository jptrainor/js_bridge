# js_bridge

Dart provides good integration between Javascript and Dart if your goal is to originate Javascript calls from the Dart side. If you want to the reverse - originate Dart function calls from the Javascript universe - then Dart's native Javascript integration is not quite as seamless. That's where js_bridge comes in. It provides a simple means of registering Dart functions that you want to make available to your Javascript code and it takes care of most of the tedious Javascript/Dart type mapping that is necessary to make the call appear as seamless as possible to the Javascript developer. 

## Getting Started

There is not much documentation yet, but it is fairly simple to use. Your best bet is to use the tests as an example. Start by looking at test/js_bridge_test.dart.

## Performance

There is a performance test included with the js_bridge unit tests. It measures the time required to complete a single function call with a single integer argument and a single integer return value. The call performance is measured both from Dart to Javascript, and from Javascript to Dart. A single function call in either direction is about 2 µs. Consider this a baseline performance expectation.

Below are the performance test results running on a 2.8 GHz i5 with OSX 10.9.3, Dart 1.4.2, and Chrome 35.0.1916.114.

Dartium (Dart VM):

    javascript call to dart = 1414 ns/call
    dart call to javascript = 2238 ns/call

Chrome (dart2js):

    javascript call to dart = 2303 ns/call
    dart call to javascript = 1442 ns/call

## Does it really work? Is it actually useful?

Yes. It is used in a real life project to put an ExtJS interface on top of a layer of Dart code that is responsible for all server communication, resource caching, etc. It works fine in this application.

Jim Trainor  
6 June 2014








