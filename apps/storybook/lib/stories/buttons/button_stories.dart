import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSButton].
final buttonStories = [
  WidgetbookUseCase(
    name: 'Primary',
    builder: (context) => ZDSButton.primary(
      label: context.knobs.string(label: 'Label', initialValue: 'Submit'),
      onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
          ? () {}
          : null,
      fullWidth: context.knobs.boolean(
        label: 'Full Width',
        initialValue: false,
      ),
      isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    ),
  ),
  WidgetbookUseCase(
    name: 'Secondary',
    builder: (context) => ZDSButton.secondary(
      label: context.knobs.string(label: 'Label', initialValue: 'Cancel'),
      onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
          ? () {}
          : null,
      fullWidth: context.knobs.boolean(
        label: 'Full Width',
        initialValue: false,
      ),
      isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
    ),
  ),
  WidgetbookUseCase(
    name: 'Text',
    builder: (context) => ZDSButton.text(
      label: context.knobs.string(label: 'Label', initialValue: 'Skip'),
      onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
          ? () {}
          : null,
    ),
  ),
  WidgetbookUseCase(
    name: 'Icon',
    builder: (context) => ZDSButton.icon(
      icon: Icons.favorite,
      tooltip: context.knobs.stringOrNull(
        label: 'Tooltip',
        initialValue: 'Add to favorites',
      ),
      onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
          ? () {}
          : null,
    ),
  ),
  WidgetbookUseCase(
    name: 'All Variants',
    builder: (context) => Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ZDSButton.primary(label: 'Primary', onPressed: () {}),
        ZDSButton.secondary(label: 'Secondary', onPressed: () {}),
        ZDSButton.text(label: 'Text', onPressed: () {}),
        ZDSButton.icon(icon: Icons.star, onPressed: () {}),
        const ZDSButton.primary(label: 'Disabled', onPressed: null),
        ZDSButton.primary(label: 'Loading', onPressed: () {}, isLoading: true),
      ],
    ),
  ),
];
