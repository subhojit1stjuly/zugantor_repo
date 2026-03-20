import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [AppSwitch].
final List<WidgetbookUseCase> switchStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'Group', builder: _group),
];

Widget _default(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Enable notifications',
  );
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return _SwitchDemo(label: label, enabled: enabled);
}

Widget _group(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SwitchDemo(label: 'Push notifications'),
        SizedBox(height: 4),
        _SwitchDemo(label: 'Email digests'),
        SizedBox(height: 4),
        _SwitchDemo(label: 'Disabled option', enabled: false),
      ],
    ),
  );
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo({this.label = 'Switch label', this.enabled = true});

  final String label;
  final bool enabled;

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return AppSwitch(
      value: _value,
      onChanged: widget.enabled ? (v) => setState(() => _value = v) : null,
      label: widget.label,
      enabled: widget.enabled,
    );
  }
}
