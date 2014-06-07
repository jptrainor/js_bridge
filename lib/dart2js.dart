// Copyright (c) 2014, Jim Trainor. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of js_bridge;

/**
 * Convert [dartobj] to a json compatible type.
 */
dynamic dart2js(var dartobj) {
  if (dartobj is Iterable || dartobj is Map) {
    return new js.JsObject.jsify(dartobj);
  }
  else {
    return dartobj;
  }
}
