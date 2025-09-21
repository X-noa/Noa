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
    final highRiskMessages = highRiskResponses.map((e) => e['message'] as String).toList();

    final presentSymptoms = messages
        .where((m) => !m['isUser'] && highRiskMessages.contains(m['text']))
        .length;

    final totalSymptoms = 4; // As per the number of high_risk messages

    if (totalSymptoms == 0) return false;

    final ratio = presentSymptoms / totalSymptoms;

    return ratio >= 0.7;
  }
}
