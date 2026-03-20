import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [AppTextInput].
final List<WidgetbookUseCase> textInputStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'All States', builder: _allStates),
];

Widget _default(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Email address',
  );
  final hint = context.knobs.string(
    label: 'Hint',
    initialValue: 'you@example.com',
  );
  final helperText = context.knobs.string(
    label: 'Helper text',
    initialValue: 'We\'ll never share your email.',
  );
  final errorText = context.knobs.stringOrNull(
    label: 'Error text',
    initialValue: null,
  );
  final stateIndex = context.knobs.int.slider(
    label: 'State (0=normal, 1=success, 2=warning, 3=error)',
    initialValue: 0,
    min: 0,
    max: 3,
    divisions: 3,
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  final states = [
    TextInputState.normal,
    TextInputState.success,
    TextInputState.warning,
    TextInputState.error,
  ];

  return SizedBox(
    width: 320,
    child: AppTextInput(
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      state: states[stateIndex],
      enabled: enabled,
      onChanged: (_) {},
    ),
  );
}

Widget _allStates(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextInput(
          label: 'Normal',
          hint: 'Enter text',
          state: TextInputState.normal,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Success',
          hint: 'Looks good',
          state: TextInputState.success,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Warning',
          hint: 'Double check this',
          state: TextInputState.warning,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Error',
          errorText: 'This field is required',
          state: TextInputState.error,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        AppTextInput(
          label: 'Disabled',
          hint: 'Not editable',
          enabled: false,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}
