import 'dart:convert';

import 'package:flutter/services.dart';

class AssetLoader {
  const AssetLoader();

  Future<List<dynamic>> loadList(String path) async {
    final content = await rootBundle.loadString(path);
    return jsonDecode(content) as List<dynamic>;
  }

  Future<Map<String, dynamic>> loadMap(String path) async {
    final content = await rootBundle.loadString(path);
    return jsonDecode(content) as Map<String, dynamic>;
  }
}
