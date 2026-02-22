import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppSwitch].
final switchStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => _SwitchDemo(
      label: context.knobs.string(
        label: 'Label',
        initialValue: 'Enable push notifications',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  ),
];

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo({required this.label, required this.enabled});

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
      label: widget.label,
      enabled: widget.enabled,
      onChanged: widget.enabled ? (v) => setState(() => _value = v) : (v) {},
    );
  }
}
