import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MockRulesEngine {
  Future<Map<String, dynamic>> _loadChatResponses() async {
    final jsonString = await rootBundle.loadString('mock/chat_responses.json');
    return json.decode(jsonString);
  }

  Future<bool> shouldShowSafetyModal(List<Map<String, dynamic>> messages) async {
    final chatResponses = await _loadChatResponses();
    final highRiskResponses = chatResponses['high_risk'] as List;
    final presentSymptomFlags = messages
        .where((m) => m['symptom_flag'] != null)
        .map((m) => m['symptom_flag'] as String)
        .toSet();

    final totalSymptoms = highRiskResponses.length;

    if (totalSymptoms == 0) return false;

    final ratio = presentSymptomFlags.length / totalSymptoms;

    return ratio >= 0.7;
  }
}
