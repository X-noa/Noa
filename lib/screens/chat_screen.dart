import 'package:flutter/material.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/services/mock_rules_engine.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/message_bubble.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/safety_modal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final MockRulesEngine _rulesEngine = MockRulesEngine();
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMicrocopy();
  }

  Future<void> _loadMicrocopy() async {
    await _microcopyService.load();
    setState(() {
      _microcopyLoaded = true;
      _messages.add(
        {'text': _microcopyService.get('chat_starter'), 'isUser': false},
      );
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });

    // Mock Noa's response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add({
          'text': "I'm really worried about what you're saying. It sounds like you're in a lot of pain.",
          'isUser': false
        });
        _messages.add({
          'text': "The way you're describing things makes me concerned for your safety.",
          'isUser': false
        });
        _messages.add({
          'text': "It sounds like you're feeling completely overwhelmed and alone right now.",
          'isUser': false
        });
      });
      _checkSafetyModal();
    });
  }

  void _checkSafetyModal() async {
    final shouldShow = await _rulesEngine.shouldShowSafetyModal(_messages);
    if (shouldShow) {
      showDialog(
        context: context,
        builder: (context) => const SafetyModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_microcopyLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: const NoaAppBar(
        title: 'Chat with Noa',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(NoaTheme.spacing8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  text: message['text'],
                  isUser: message['isUser'],
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: NoaTheme.primary,
          ),
        ],
      ),
    );
  }
}
