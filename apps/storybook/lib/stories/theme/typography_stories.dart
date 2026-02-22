import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for ZDS typography tokens.
final typographyStories = [
  WidgetbookUseCase(
    name: 'Type Scale',
    builder: (context) => const _TypeScale(),
  ),
];

class _TypeScale extends StatelessWidget {
  const _TypeScale();

  @override
  Widget build(BuildContext context) {
    final typo = context.typography;

    final styles = [
      ('headlineLarge', typo.headlineLarge),
      ('headlineMedium', typo.headlineMedium),
      ('headlineSmall', typo.headlineSmall),
      ('titleLarge', typo.titleLarge),
      ('titleMedium', typo.titleMedium),
      ('titleSmall', typo.titleSmall),
      ('bodyLarge', typo.bodyLarge),
      ('bodyMedium', typo.bodyMedium),
      ('bodySmall', typo.bodySmall),
      ('labelLarge', typo.labelLarge),
      ('labelMedium', typo.labelMedium),
      ('labelSmall', typo.labelSmall),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: styles
            .map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.$1, style: context.typography.labelSmall),
                    Text('The quick brown fox', style: s.$2),
                    const Divider(),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
