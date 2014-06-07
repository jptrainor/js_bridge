part of js_bridge;

/**
 * Convert [jsobj] to a json compatible type.
 */
dynamic dart2js(var dartobj) {
  if (dartobj is Iterable || dartobj is Map) {
    return new js.JsObject.jsify(dartobj);
  }
  else {
    return dartobj;
  }
}
