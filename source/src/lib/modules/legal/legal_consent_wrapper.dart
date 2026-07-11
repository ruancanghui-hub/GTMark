import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'legal_consent_gate.dart';

const _kLegalConsentAccepted = 'prefs_legal_consent_accepted';

/// 首次启动未同意协议时，在 [child] 之上全屏展示 [LegalConsentGate]。
class LegalConsentWrapper extends StatefulWidget {
  const LegalConsentWrapper({
    super.key,
    required this.child,
    this.onConsentAccepted,
  });

  final Widget child;
  final VoidCallback? onConsentAccepted;

  @override
  State<LegalConsentWrapper> createState() => _LegalConsentWrapperState();
}

class _LegalConsentWrapperState extends State<LegalConsentWrapper> {
  bool? _accepted;
  bool _notifiedAccepted = false;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final accepted = prefs.getBool(_kLegalConsentAccepted) ?? false;
    setState(() {
      _accepted = accepted;
    });
    if (accepted) _notifyAcceptedOnce();
  }

  Future<void> _onAgreed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLegalConsentAccepted, true);
    if (!mounted) return;
    setState(() => _accepted = true);
    _notifyAcceptedOnce();
  }

  void _notifyAcceptedOnce() {
    if (_notifiedAccepted) return;
    _notifiedAccepted = true;
    widget.onConsentAccepted?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_accepted == null) {
      return const ColoredBox(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (!_accepted!)
          Positioned.fill(child: LegalConsentGate(onAgreed: _onAgreed)),
      ],
    );
  }
}
