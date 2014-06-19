// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library js_bridge_test_main;

import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:js_bridge/test/js_bridge_test.dart' as jsb_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'perf_test.dart';

main() {
  useHtmlConfiguration();
  jsb_test.setupTests();

  setupPerfTest();
}
