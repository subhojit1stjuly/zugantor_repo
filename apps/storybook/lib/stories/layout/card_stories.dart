import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [AppCard].
final List<WidgetbookUseCase> cardStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'All Elevations', builder: _allElevations),
];

Widget _default(BuildContext context) {
  final elevationIndex = context.knobs.int.slider(
    label: 'Elevation (0=low, 1=medium, 2=high)',
    initialValue: 0,
    min: 0,
    max: 2,
    divisions: 2,
  );
  final tappable = context.knobs.boolean(
    label: 'Tappable',
    initialValue: false,
  );

  final elevations = [
    CardElevation.low,
    CardElevation.medium,
    CardElevation.high,
  ];

  return AppCard(
    elevation: elevations[elevationIndex],
    onTap: tappable ? () {} : null,
    child: const _SampleCardContent(
      title: 'Card title',
      subtitle: 'Supporting text goes here.',
    ),
  );
}

Widget _allElevations(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCard(
          elevation: CardElevation.low,
          child: const _SampleCardContent(title: 'Low elevation'),
        ),
        const SizedBox(height: 16),
        AppCard(
          elevation: CardElevation.medium,
          child: const _SampleCardContent(title: 'Medium elevation'),
        ),
        const SizedBox(height: 16),
        AppCard(
          elevation: CardElevation.high,
          child: const _SampleCardContent(title: 'High elevation'),
        ),
      ],
    ),
  );
}

class _SampleCardContent extends StatelessWidget {
  const _SampleCardContent({
    required this.title,
    this.subtitle = 'Card content goes here.',
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: ZDSTheme.of(context).typography.titleMedium),
        const SizedBox(height: 4),
        Text(subtitle, style: ZDSTheme.of(context).typography.bodyMedium),
      ],
    );
  }
}
