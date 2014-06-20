// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library benchmark;

import 'dart:async';
import 'dart:js' as js;

import 'package:js_bridge/js_bridge.dart' as jsb;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

part 'perf_test.dart';

main() {
  useHtmlConfiguration();
  setupPerfTest();
}
