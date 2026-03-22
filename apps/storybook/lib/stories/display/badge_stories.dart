import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSBadge].
final List<WidgetbookUseCase> badgeStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'All Variants', builder: _allVariants),
  WidgetbookUseCase(name: 'Overlay', builder: _overlay),
  WidgetbookUseCase(name: 'Semantic Colors', builder: _semanticColors),
];

Widget _default(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'New');
  final variantIndex = context.knobs.int.slider(
    label: 'Variant (0=filled, 1=outlined, 2=soft)',
    initialValue: 0,
    min: 0,
    max: 2,
    divisions: 2,
  );

  final variants = [
    BadgeVariant.filled,
    BadgeVariant.outlined,
    BadgeVariant.soft,
  ];

  return ZDSBadge(label: label, variant: variants[variantIndex]);
}

Widget _allVariants(BuildContext context) {
  return Wrap(
    spacing: 12,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: const [
      ZDSBadge(label: 'Filled', variant: BadgeVariant.filled),
      ZDSBadge(label: 'Outlined', variant: BadgeVariant.outlined),
      ZDSBadge(label: 'Soft', variant: BadgeVariant.soft),
    ],
  );
}

Widget _overlay(BuildContext context) {
  final count = context.knobs.int.slider(
    label: 'Count',
    initialValue: 5,
    min: 0,
    max: 200,
    divisions: 40,
  );

  return Wrap(
    spacing: 24,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      ZDSBadge.overlay(
        count: count,
        child: const Icon(Icons.notifications, size: 28),
      ),
      ZDSBadge.overlay(
        count: count,
        maxCount: 99,
        child: const Icon(Icons.shopping_cart, size: 28),
      ),
      ZDSBadge.overlay(
        count: count,
        maxCount: 9,
        child: const Icon(Icons.mail_outline, size: 28),
      ),
    ],
  );
}

Widget _semanticColors(BuildContext context) {
  final colors = ZDSTheme.of(context).colors;

  return Wrap(
    spacing: 12,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      ZDSBadge(label: 'Success', color: colors.success),
      ZDSBadge(label: 'Warning', color: colors.warning),
      ZDSBadge(label: 'Error', color: colors.error),
      ZDSBadge(label: 'Info', color: colors.info),
    ],
  );
}
