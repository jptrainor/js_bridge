# js_bridge

Dart provides good integration between Javascript and Dart if your goal is to originate Javascript calls from the Dart side. If you want to do the reverse - originate Dart function calls from Javascript - then Dart's native Javascript integration is not quite as seamless. That's where js_bridge helps. It provides a simple means of registering Dart functions that you want to make available to your Javascript code and it takes care of most of the tedious Javascript/Dart type mapping that is necessary to make the call appear as seamless as possible to both the Dart and Javascript developers.

## Getting Started

There is a simple example that shows how to get started.

You need to create a JsBridge object in your Dart code and use that bridge object to register functions that you want exposed to your Javascript code. The dart code is responsible for calling JsBridge.notifyReady() after the bridge is initialized and ready to be called by your Javascript code. On the Javascript side you need to include js_bridge.js and add a ready notification listener to get the namespace object that was created by the Dart side JsBridge instance. With that namespace object you can then call your registered functions by name using ordinary javascript dot notation.

## Performance

The js_bridge package includes a performance benchmark. It measures the time required to complete a single function call with a single integer argument and a single integer return value using both bare dart:js and js_bridge.

The dart:js benchmark measures the time required to call from both from Dart to Javascript, and from Javascript to Dart. A single function call in either direction completes in about 2 µs.

The js_bridge benchmark measures the time required to complete a single bridged function call with a single integer argument and a single integer return value. A single bridged Javascript to Dart call completes in about 3 µs.

Below are the benchmark test results running on a 2.8 GHz i5 with OSX 10.9.3, Dart 1.4.3, and Chrome 35.0.1916.114.

Dartium (Dart VM):

    bare javascript call to dart = 1345 ns call
    bare dart call to javascript = 2103 ns/call
    js_bridge javascript call to dart = 2654 ns/call

Chrome (dart2js):

    bare javascript call to dart = 1929 ns/call
    bare dart call to javascript = 1278 ns/call
    js_bridge javascript call to dart = 2909 ns/call

## Does it really work? Is it actually useful?

Yes. It is used in a real life project to put a Polymer/Javascript interface on top of a layer of Dart code that is responsible for all server communication, resource caching, etc. It works fine in this application.




