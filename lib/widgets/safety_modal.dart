import 'package:flutter/material.dart';
import 'package:noa/services/microcopy_service.dart';
import 'package:noa/theme/noa_theme.dart';
import 'package:noa/widgets/ghost_button.dart';
import 'package:noa/widgets/primary_button.dart';

class SafetyModal extends StatefulWidget {
  const SafetyModal({super.key});

  @override
  State<SafetyModal> createState() => _SafetyModalState();
}

class _SafetyModalState extends State<SafetyModal> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // The content of the modal, to be used with a generic dialog builder
    // like showNoaModal.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Material(
          color: NoaTheme.background,
          borderRadius: BorderRadius.circular(NoaTheme.modalRadius),
          child: Padding(
            padding: const EdgeInsets.all(NoaTheme.spacing24),
            child: _microcopyLoaded
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.support, size: 48, color: NoaTheme.primary),
                      const SizedBox(height: NoaTheme.spacing16),
                      Text(_microcopyService.get('safety_modal_title'), style: NoaTheme.h2, textAlign: TextAlign.center),
                      const SizedBox(height: NoaTheme.spacing16),
                      Text(
                        _microcopyService.get('safety_modal_body'),
                        textAlign: TextAlign.center,
                        style: NoaTheme.body,
                      ),
                      const SizedBox(height: NoaTheme.spacing32),
                      PrimaryButton(
                        onPressed: () {
                          // TODO: Navigate to resources screen
                        },
                        text: 'Find a specialist',
                      ),
                      const SizedBox(height: NoaTheme.spacing8),
                      GhostButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Later',
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
