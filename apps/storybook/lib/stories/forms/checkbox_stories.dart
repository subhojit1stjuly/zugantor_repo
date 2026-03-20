import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSCheckbox].
final List<WidgetbookUseCase> checkboxStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'Group', builder: _group),
];

Widget _default(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'I agree to the terms and conditions',
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return _CheckboxDemo(label: label, enabled: enabled);
}

Widget _group(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CheckboxDemo(label: 'Newsletter updates'),
        SizedBox(height: 4),
        _CheckboxDemo(label: 'Product announcements'),
        SizedBox(height: 4),
        _CheckboxDemo(label: 'Disabled option', enabled: false),
      ],
    ),
  );
}

class _CheckboxDemo extends StatefulWidget {
  const _CheckboxDemo({this.label = 'Checkbox label', this.enabled = true});

  final String label;
  final bool enabled;

  @override
  State<_CheckboxDemo> createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return ZDSCheckbox(
      value: _value,
      onChanged: widget.enabled
          ? (v) => setState(() => _value = v ?? false)
          : null,
      label: widget.label,
      enabled: widget.enabled,
    );
  }
}
