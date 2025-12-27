import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MicrocopyService {
  late Map<String, String> _microcopy;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('mock/microcopy.json');
    _microcopy = Map<String, String>.from(json.decode(jsonString));
  }

  String get(String key) {
    return _microcopy[key] ?? '';
  }
}
