import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSTextInput].
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
    ZDSTextInputState.normal,
    ZDSTextInputState.success,
    ZDSTextInputState.warning,
    ZDSTextInputState.error,
  ];

  return SizedBox(
    width: 320,
    child: ZDSTextInput(
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
        ZDSTextInput(
          label: 'Normal',
          hint: 'Enter text',
          state: ZDSTextInputState.normal,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        ZDSTextInput(
          label: 'Success',
          hint: 'Looks good',
          state: ZDSTextInputState.success,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        ZDSTextInput(
          label: 'Warning',
          hint: 'Double check this',
          state: ZDSTextInputState.warning,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        ZDSTextInput(
          label: 'Error',
          errorText: 'This field is required',
          state: ZDSTextInputState.error,
          onChanged: (_) {},
        ),
        const SizedBox(height: 12),
        ZDSTextInput(
          label: 'Disabled',
          hint: 'Not editable',
          enabled: false,
          onChanged: (_) {},
        ),
      ],
    ),
  );
}
