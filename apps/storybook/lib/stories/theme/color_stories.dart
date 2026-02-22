import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for the ZDS color palette.
final colorStories = [
  WidgetbookUseCase(
    name: 'Full Palette',
    builder: (context) => const _ColorPalette(),
  ),
];

class _ColorPalette extends StatelessWidget {
  const _ColorPalette();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final swatches = [
      ('Primary', colors.primary),
      ('Secondary', colors.secondary),
      ('Background', colors.background),
      ('Bg Secondary', colors.backgroundSecondary),
      ('Surface', colors.surface),
      ('Error', colors.error),
      ('Success', colors.success),
      ('Warning', colors.warning),
      ('Info', colors.info),
      ('Border', colors.border),
      ('Divider', colors.divider),
      ('Disabled', colors.disabled),
      ('Text Primary', colors.textPrimary),
      ('Text Secondary', colors.textSecondary),
      ('Text Tertiary', colors.textTertiary),
      ('Hover', colors.hover),
      ('Pressed', colors.pressed),
      ('Focus', colors.focus),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children:
            swatches.map((s) => _Swatch(label: s.$1, color: s.$2)).toList(),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: context.typography.labelSmall,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
