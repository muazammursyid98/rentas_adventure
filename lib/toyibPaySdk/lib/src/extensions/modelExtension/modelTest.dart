import 'dart:convert';

bool modelTest(model, responseBody, {wrapper}) {
  wrapper ??= (text) {
    return '$text';
  };
  Map decodedResp = json.decode(wrapper(responseBody));
  Map modelToJson = model.toJson();
  var keys = modelToJson.keys.map((e) => e.toLowerCase()).toList();
  var ok = true;
  decodedResp.forEach((key, val) {
    if (modelToJson[key] == null) {
      print('- modelToJson `$key` is notequal');
      if (keys.contains(key.toLowerCase())) {
        print('  - but $key in different case');
      }
      if (ok) ok = false;
    }
  });
  return ok;
}
