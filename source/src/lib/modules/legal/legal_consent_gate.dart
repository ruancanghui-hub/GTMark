import 'dart:io' show exit;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lianji/l10n/gen/app_localizations.dart';

import 'package:lianji/shared/utils/modular_nav_context.dart';

import 'legal_asset_paths.dart';
import 'legal_documents_pages.dart';

/// 首次启动未同意协议时全屏展示；同意前拦截主界面操作。
class LegalConsentGate extends StatelessWidget {
  const LegalConsentGate({
    super.key,
    required this.onAgreed,
  });

  final VoidCallback onAgreed;

  static void _exitApp() {
    if (kIsWeb) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.legalConsentTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.legalConsentMessage,
                style: textTheme.bodyLarge?.copyWith(height: 1.45),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      final navCtx = modularRootContext();
                      if (navCtx == null) return;
                      showLegalDocumentModal(
                        navCtx,
                        title: l10n.legalTermsTitle,
                        assetPath: LegalAssetPaths.termsPath(locale),
                        loadErrorMessage: l10n.legalMdLoadError,
                      );
                    },
                    child: Text(l10n.legalConsentViewTerms),
                  ),
                  TextButton(
                    onPressed: () {
                      final navCtx = modularRootContext();
                      if (navCtx == null) return;
                      showLegalDocumentModal(
                        navCtx,
                        title: l10n.legalPrivacyTitle,
                        assetPath: LegalAssetPaths.privacyPath(locale),
                        loadErrorMessage: l10n.legalMdLoadError,
                      );
                    },
                    child: Text(l10n.legalConsentViewPrivacy),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: onAgreed,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(l10n.legalConsentAgree),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _exitApp,
                child: Text(l10n.legalConsentDisagree),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
