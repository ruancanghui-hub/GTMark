import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lianji/l10n/gen/app_localizations.dart';
import 'package:lianji/shared/ui/jichen_secondary_scaffold.dart';

import 'legal_asset_paths.dart';

/// 自底部弹出全文（Overlay 层，可盖在首次同意门闸之上）。
Future<void> showLegalDocumentModal(
  BuildContext context, {
  required String title,
  required String assetPath,
  required String loadErrorMessage,
}) {
  final theme = Theme.of(context);
  final sheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
    blockSpacing: 12,
    h1: theme.textTheme.headlineSmall,
    h2: theme.textTheme.titleLarge,
    h3: theme.textTheme.titleMedium,
    p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
    listBullet: theme.textTheme.bodyLarge,
    a: theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
  );

  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: theme.colorScheme.surface,
    builder: (ctx) {
      final h = MediaQuery.sizeOf(ctx).height * 0.92;
      return SafeArea(
        child: SizedBox(
          height: h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              Expanded(
                child: FutureBuilder<String>(
                  future: rootBundle.loadString(assetPath),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || snapshot.data == null) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(loadErrorMessage),
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: MarkdownBody(
                        data: snapshot.data!,
                        styleSheet: sheet,
                        selectable: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 隐私政策（语言随 [MaterialApp.locale]：中文 [LegalAssetPaths.privacyZh]，英文 [LegalAssetPaths.privacyEn]）
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return _LegalMarkdownPage(
      title: l10n.legalPrivacyTitle,
      assetPath: LegalAssetPaths.privacyPath(locale),
      loadErrorMessage: l10n.legalMdLoadError,
    );
  }
}

/// 用户协议（语言随 [MaterialApp.locale]：中文 [LegalAssetPaths.termsZh]，英文 [LegalAssetPaths.termsEn]）
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return _LegalMarkdownPage(
      title: l10n.legalTermsTitle,
      assetPath: LegalAssetPaths.termsPath(locale),
      loadErrorMessage: l10n.legalMdLoadError,
    );
  }
}

class _LegalMarkdownPage extends StatefulWidget {
  const _LegalMarkdownPage({
    required this.title,
    required this.assetPath,
    required this.loadErrorMessage,
  });

  final String title;
  final String assetPath;
  final String loadErrorMessage;

  @override
  State<_LegalMarkdownPage> createState() => _LegalMarkdownPageState();
}

class _LegalMarkdownPageState extends State<_LegalMarkdownPage> {
  late Future<String> _load;

  @override
  void initState() {
    super.initState();
    _load = rootBundle.loadString(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sheet = MarkdownStyleSheet.fromTheme(theme).copyWith(
      blockSpacing: 12,
      h1: theme.textTheme.headlineSmall,
      h2: theme.textTheme.titleLarge,
      h3: theme.textTheme.titleMedium,
      p: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
      listBullet: theme.textTheme.bodyLarge,
      a: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
    );

    return JichenSecondaryScaffold(
      title: widget.title,
      padding: EdgeInsets.zero,
      scrollable: false,
      body: FutureBuilder<String>(
        future: _load,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(widget.loadErrorMessage),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: MarkdownBody(
              data: snapshot.data!,
              styleSheet: sheet,
              selectable: true,
            ),
          );
        },
      ),
    );
  }
}
