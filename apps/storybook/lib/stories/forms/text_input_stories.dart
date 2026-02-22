import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppTextInput].
final textInputStories = [
  WidgetbookUseCase(
    name: 'Normal',
    builder: (context) => AppTextInput(
      label: context.knobs.string(label: 'Label', initialValue: 'Email'),
      hint: context.knobs.stringOrNull(
        label: 'Hint',
        initialValue: 'you@example.com',
      ),
      helperText: context.knobs.stringOrNull(
        label: 'Helper',
        initialValue: 'We never share your email',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
      onChanged: (_) {},
    ),
  ),
  WidgetbookUseCase(
    name: 'All States',
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextInput(label: 'Normal', hint: 'Enter text', onChanged: (_) {}),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Success',
          state: TextInputState.success,
          prefixIcon: Icons.check_circle_outline,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Warning',
          state: TextInputState.warning,
          prefixIcon: Icons.warning_amber_outlined,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Error',
          state: TextInputState.error,
          errorText: 'This field is required',
          prefixIcon: Icons.error_outline,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(label: 'Disabled', enabled: false, onChanged: (_) {}),
      ],
    ),
  ),
];
