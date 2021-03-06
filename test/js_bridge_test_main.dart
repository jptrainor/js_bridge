// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library js_bridge_test_main;

import 'tests/js_bridge_test.dart' as jsb_test;
import 'package:unittest/html_config.dart';

main() {
  useHtmlConfiguration();
  jsb_test.setupTests();
}
