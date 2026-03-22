import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for the ZDSColors design token palette.
final List<WidgetbookUseCase> colorStories = [
  WidgetbookUseCase(name: 'All Colors', builder: _allColors),
  WidgetbookUseCase(name: 'Semantic Colors', builder: _semanticColors),
];

Widget _allColors(BuildContext context) {
  final ZDSColors colors = ZDSTheme.of(context).colors;

  final swatches = <_SwatchEntry>[
    _SwatchEntry(color: colors.primary, label: 'Primary'),
    _SwatchEntry(color: colors.secondary, label: 'Secondary'),
    _SwatchEntry(color: colors.background, label: 'Background'),
    _SwatchEntry(color: colors.surface, label: 'Surface'),
    _SwatchEntry(color: colors.error, label: 'Error'),
    _SwatchEntry(color: colors.success, label: 'Success'),
    _SwatchEntry(color: colors.warning, label: 'Warning'),
    _SwatchEntry(color: colors.info, label: 'Info'),
    _SwatchEntry(color: colors.border, label: 'Border'),
    _SwatchEntry(color: colors.divider, label: 'Divider'),
    _SwatchEntry(color: colors.disabled, label: 'Disabled'),
    _SwatchEntry(color: colors.onPrimary, label: 'On Primary'),
    _SwatchEntry(color: colors.onSecondary, label: 'On Secondary'),
    _SwatchEntry(color: colors.onBackground, label: 'On Background'),
    _SwatchEntry(color: colors.onSurface, label: 'On Surface'),
    _SwatchEntry(color: colors.onError, label: 'On Error'),
    _SwatchEntry(color: colors.onSuccess, label: 'On Success'),
    _SwatchEntry(color: colors.onWarning, label: 'On Warning'),
    _SwatchEntry(color: colors.onInfo, label: 'On Info'),
  ];

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: swatches.map(_ColorSwatch.new).toList(),
    ),
  );
}

Widget _semanticColors(BuildContext context) {
  final ZDSColors colors = ZDSTheme.of(context).colors;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SemanticRow(
          bg: colors.success,
          fg: colors.onSuccess,
          label: 'Success',
        ),
        const SizedBox(height: 8),
        _SemanticRow(
          bg: colors.warning,
          fg: colors.onWarning,
          label: 'Warning',
        ),
        const SizedBox(height: 8),
        _SemanticRow(bg: colors.error, fg: colors.onError, label: 'Error'),
        const SizedBox(height: 8),
        _SemanticRow(bg: colors.info, fg: colors.onInfo, label: 'Info'),
      ],
    ),
  );
}

class _SwatchEntry {
  const _SwatchEntry({required this.color, required this.label});
  final Color? color;
  final String label;
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(this.entry);
  final _SwatchEntry entry;

  @override
  Widget build(BuildContext context) {
    final color = entry.color ?? Colors.transparent;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(height: 4),
        Text(entry.label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

class _SemanticRow extends StatelessWidget {
  const _SemanticRow({required this.bg, required this.fg, required this.label});

  final Color? bg;
  final Color? fg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg ?? Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label — sample text',
        style: TextStyle(color: fg, fontWeight: FontWeight.w500),
      ),
    );
  }
}
