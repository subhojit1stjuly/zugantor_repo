import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for ZDSTypography design tokens.
final List<WidgetbookUseCase> typographyStories = [
  WidgetbookUseCase(name: 'All Styles', builder: _allStyles),
  WidgetbookUseCase(name: 'Knob Preview', builder: _knobPreview),
];

const _styles = <_StyleEntry>[
  _StyleEntry(label: 'headlineLarge'),
  _StyleEntry(label: 'headlineMedium'),
  _StyleEntry(label: 'headlineSmall'),
  _StyleEntry(label: 'titleLarge'),
  _StyleEntry(label: 'titleMedium'),
  _StyleEntry(label: 'titleSmall'),
  _StyleEntry(label: 'bodyLarge'),
  _StyleEntry(label: 'bodyMedium'),
  _StyleEntry(label: 'bodySmall'),
  _StyleEntry(label: 'labelLarge'),
  _StyleEntry(label: 'labelMedium'),
  _StyleEntry(label: 'labelSmall'),
];

Widget _allStyles(BuildContext context) {
  final ZDSTypography type = ZDSTheme.of(context).typography;

  TextStyle? resolve(String name) => switch (name) {
    'headlineLarge' => type.headlineLarge,
    'headlineMedium' => type.headlineMedium,
    'headlineSmall' => type.headlineSmall,
    'titleLarge' => type.titleLarge,
    'titleMedium' => type.titleMedium,
    'titleSmall' => type.titleSmall,
    'bodyLarge' => type.bodyLarge,
    'bodyMedium' => type.bodyMedium,
    'bodySmall' => type.bodySmall,
    'labelLarge' => type.labelLarge,
    'labelMedium' => type.labelMedium,
    'labelSmall' => type.labelSmall,
    _ => null,
  };

  return ListView(
    padding: const EdgeInsets.all(16),
    children: _styles.map((entry) {
      final style = resolve(entry.label);
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text('The quick brown fox jumps over the lazy dog', style: style),
          ],
        ),
      );
    }).toList(),
  );
}

Widget _knobPreview(BuildContext context) {
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'The quick brown fox',
  );
  final styleIndex = context.knobs.int.slider(
    label: 'Style',
    initialValue: 6,
    min: 0,
    max: 11,
    divisions: 11,
  );

  final ZDSTypography type = ZDSTheme.of(context).typography;

  final styles = [
    type.headlineLarge,
    type.headlineMedium,
    type.headlineSmall,
    type.titleLarge,
    type.titleMedium,
    type.titleSmall,
    type.bodyLarge,
    type.bodyMedium,
    type.bodySmall,
    type.labelLarge,
    type.labelMedium,
    type.labelSmall,
  ];

  final styleName = _styles[styleIndex].label;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          styleName,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(text, style: styles[styleIndex]),
      ],
    ),
  );
}

class _StyleEntry {
  const _StyleEntry({required this.label});
  final String label;
}
