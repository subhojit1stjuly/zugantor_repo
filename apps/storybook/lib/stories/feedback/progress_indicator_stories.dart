import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSProgressIndicator].
final progressIndicatorStories = [
  WidgetbookUseCase(
    name: 'Circular',
    builder: (context) {
      final indeterminate = context.knobs.boolean(
        label: 'Indeterminate',
        initialValue: true,
      );
      final value = context.knobs.double.slider(
        label: 'Value',
        initialValue: 0.5,
        min: 0,
        max: 1,
        divisions: 20,
      );
      final size = context.knobs.double.slider(
        label: 'Size',
        initialValue: 36,
        min: 20,
        max: 80,
        divisions: 12,
      );
      return ZDSProgressIndicator(
        value: indeterminate ? null : value,
        size: size,
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Linear',
    builder: (context) {
      final indeterminate = context.knobs.boolean(
        label: 'Indeterminate',
        initialValue: false,
      );
      final value = context.knobs.double.slider(
        label: 'Value',
        initialValue: 0.6,
        min: 0,
        max: 1,
        divisions: 20,
      );
      return SizedBox(
        width: 300,
        child: ZDSProgressIndicator.linear(
          value: indeterminate ? null : value,
        ),
      );
    },
  ),
];
