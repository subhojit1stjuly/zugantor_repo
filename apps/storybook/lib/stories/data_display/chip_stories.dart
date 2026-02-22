import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSChip].
final chipStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final label = context.knobs.string(
        label: 'Label',
        initialValue: 'In Stock',
      );
      final variantIndex = context.knobs.int.slider(
        label: 'Variant (0=neutral…5=info)',
        initialValue: 0,
        min: 0,
        max: ZDSChipVariant.values.length - 1,
        divisions: ZDSChipVariant.values.length - 1,
      );
      final isSelected = context.knobs.boolean(
        label: 'Selected',
        initialValue: false,
      );
      final deletable = context.knobs.boolean(
        label: 'Deletable',
        initialValue: false,
      );
      return ZDSChip(
        label: label,
        variant: ZDSChipVariant.values[variantIndex],
        isSelected: isSelected,
        onTap: () {},
        onDelete: deletable ? () {} : null,
      );
    },
  ),
  WidgetbookUseCase(
    name: 'All Variants',
    builder: (context) => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ZDSChipVariant.values
          .map(
            (v) => ZDSChip(
              label: v.name[0].toUpperCase() + v.name.substring(1),
              variant: v,
            ),
          )
          .toList(),
    ),
  ),
  WidgetbookUseCase(
    name: 'Selected States',
    builder: (context) => Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ZDSChipVariant.values
          .map(
            (v) => ZDSChip(
              label: v.name[0].toUpperCase() + v.name.substring(1),
              variant: v,
              isSelected: true,
            ),
          )
          .toList(),
    ),
  ),
];
