import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSButton].
final List<WidgetbookUseCase> buttonStories = [
  WidgetbookUseCase(
    name: 'Primary / Secondary / Text',
    builder: _labeledButtons,
  ),
  WidgetbookUseCase(name: 'Icon Button', builder: _iconButton),
  WidgetbookUseCase(name: 'Full Width', builder: _fullWidth),
  WidgetbookUseCase(name: 'All Variants', builder: _allVariants),
];

Widget _labeledButtons(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Click me');
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  final handler = disabled ? null : () {};

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      ZDSButton.primary(label: label, onPressed: handler),
      ZDSButton.secondary(label: label, onPressed: handler),
      ZDSButton.text(label: label, onPressed: handler),
    ],
  );
}

Widget _iconButton(BuildContext context) {
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  return ZDSButton.icon(
    icon: Icons.favorite,
    onPressed: disabled ? null : () {},
    tooltip: 'Favorite',
  );
}

Widget _fullWidth(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Submit');
  final disabled = context.knobs.boolean(
    label: 'Disabled',
    initialValue: false,
  );

  return SizedBox(
    width: 320,
    child: ZDSButton.primary(
      label: label,
      onPressed: disabled ? null : () {},
      fullWidth: true,
    ),
  );
}

Widget _allVariants(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _VariantRow(label: 'Primary', enabled: true),
        const SizedBox(height: 8),
        const _VariantRow(label: 'Primary', enabled: false),
        const SizedBox(height: 8),
        const _VariantRow(
          label: 'Secondary',
          variant: ZDSButtonVariant.secondary,
          enabled: true,
        ),
        const SizedBox(height: 8),
        const _VariantRow(
          label: 'Secondary',
          variant: ZDSButtonVariant.secondary,
          enabled: false,
        ),
        const SizedBox(height: 8),
        const _VariantRow(
          label: 'Text',
          variant: ZDSButtonVariant.text,
          enabled: true,
        ),
        const SizedBox(height: 8),
        const _VariantRow(
          label: 'Text',
          variant: ZDSButtonVariant.text,
          enabled: false,
        ),
      ],
    ),
  );
}

class _VariantRow extends StatelessWidget {
  const _VariantRow({
    required this.label,
    required this.enabled,
    this.variant = ZDSButtonVariant.primary,
  });

  final String label;
  final bool enabled;
  final ZDSButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final handler = enabled ? () {} : null;
    final suffix = enabled ? '' : ' (disabled)';

    return switch (variant) {
      ZDSButtonVariant.primary => ZDSButton.primary(
        label: '$label$suffix',
        onPressed: handler,
      ),
      ZDSButtonVariant.secondary => ZDSButton.secondary(
        label: '$label$suffix',
        onPressed: handler,
      ),
      ZDSButtonVariant.text => ZDSButton.text(
        label: '$label$suffix',
        onPressed: handler,
      ),
      ZDSButtonVariant.icon => ZDSButton.icon(
        icon: Icons.star,
        onPressed: handler,
      ),
    };
  }
}
