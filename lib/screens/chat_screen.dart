import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/services/mock_rules_engine.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/message_bubble.dart';
import 'package:noa/widgets/noa_app_bar.dart';
import 'package:noa/widgets/noa_modal.dart';
import 'package:noa/widgets/safety_modal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final MockRulesEngine _rulesEngine = MockRulesEngine();
  final MicrocopyService _microcopyService = MicrocopyService();
  bool _microcopyLoaded = false;
  bool _isTyping = false;
  late Map<String, dynamic> _chatResponses;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _microcopyService.load();
    final jsonString = await rootBundle.loadString('mock/chat_responses.json');
    _chatResponses = json.decode(jsonString);
    if (mounted) {
      setState(() {
        _microcopyLoaded = true;
        _addMessage(
          {'text': _microcopyService.get('chat_starter'), 'isUser': false},
          isInitial: true,
        );
      });
    }
  }

  void _addMessage(Map<String, dynamic> message, {bool isInitial = false}) {
    _messages.insert(0, message);
    if (!isInitial && _listKey.currentState != null) {
      _listKey.currentState!.insertItem(0, duration: NoaMotion.standardTransition);
    }
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
      _addMessage({'text': text, 'isUser': true});
      _isTyping = true;
    });

    // Mock Noa's response
    Future.delayed(const Duration(milliseconds: 1500), () {
      final responses = _chatResponses['supportive'] as List;
      final response = responses[DateTime.now().millisecond % responses.length];
      setState(() {
        _isTyping = false;
        _addMessage({'text': response, 'isUser': false});
      });
      _checkSafetyModal();
    });
  }

  void _triggerSafetyModal() {
    final highRiskResponses = _chatResponses['high_risk'] as List;
    for (var response in highRiskResponses) {
      setState(() {
         _addMessage({
            'text': response['message'],
            'isUser': false,
            'symptom_flag': response['symptom_flag'],
          });
      });
    }
    _checkSafetyModal();
  }

  void _checkSafetyModal() async {
    final shouldShow = await _rulesEngine.shouldShowSafetyModal(_messages);
    if (shouldShow && mounted) {
      showNoaModal(context, child: const SafetyModal());
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
      appBar: NoaAppBar(
        title: 'Chat with Noa',
        actions: [
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: _triggerSafetyModal,
            tooltip: 'Trigger Safety Modal (Debug)',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              reverse: true,
              padding: const EdgeInsets.all(NoaTheme.spacing8),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final message = _messages[index];
                return _buildMessageItem(message, animation);
              },
            ),
          ),
          if (_isTyping) const TypingIndicator(),
          _buildQuickChips(),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: MessageBubble(
          text: message['text'],
          isUser: message['isUser'],
        ),
      ),
    );
  }

  Widget _buildQuickChips() {
    // Mocked chips
    final chips = ["Tell me more", "I'm feeling down", "Got a joke?"];
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: NoaTheme.spacing8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: NoaTheme.spacing16),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        itemBuilder: (context, index) {
          return QuickChip(
            text: chips[index],
            onTap: () => _handleSubmitted(chips[index]),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: NoaTheme.spacing8),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.all(NoaTheme.spacing8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [NoaTheme.cardShadow],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: _microcopyService.get('chat_input_hint'),
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
      ),
    );
  }
}

class QuickChip extends StatefulWidget {
  const QuickChip({super.key, required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  State<QuickChip> createState() => _QuickChipState();
}

class _QuickChipState extends State<QuickChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: NoaMotion.microPress,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: NoaTheme.spacing16, vertical: NoaTheme.spacing8),
          decoration: BoxDecoration(
            color: NoaTheme.neutralSurface,
            borderRadius: BorderRadius.circular(NoaTheme.buttonRadius),
          ),
          child: Center(child: Text(widget.text, style: NoaTheme.body)),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        children: [
          _buildDot(0),
          const SizedBox(width: 4),
          _buildDot(1),
          const SizedBox(width: 4),
          _buildDot(2),
          const SizedBox(width: NoaTheme.spacing12),
          const Text("Noa is thinking...", style: NoaTheme.small),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final animation = _controller.drive(
      Tween(begin: 0.0, end: 1.0).chain(
        CurveTween(
          curve: Interval(
            0.1 * index,
            0.5 + 0.1 * index,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
    return FadeTransition(
      opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
      child: ScaleTransition(
        scale: Tween(begin: 0.8, end: 1.0).animate(animation),
        child: const CircleAvatar(
          radius: 4,
          backgroundColor: NoaTheme.mutedText,
        ),
      ),
    );
  }
}
