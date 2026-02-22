import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppCheckbox].
final checkboxStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => _CheckboxDemo(
      label: context.knobs.string(
        label: 'Label',
        initialValue: 'Accept terms and conditions',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  ),
];

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return AppCheckbox(
      value: _value,
      label: widget.label,
      enabled: widget.enabled,
      onChanged:
          widget.enabled ? (v) => setState(() => _value = v ?? false) : null,
    );
  }
}
