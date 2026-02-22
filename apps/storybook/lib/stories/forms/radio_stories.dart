import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppRadioGroup].
final radioStories = [
  WidgetbookUseCase(name: 'Default', builder: (context) => const _RadioDemo()),
];

class _RadioDemo extends StatefulWidget {
  const _RadioDemo();

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String _value = 'a';

  @override
  Widget build(BuildContext context) {
    return AppRadioGroup<String>(
      value: _value,
      label: 'Shipping method',
      onChanged: (v) => setState(() => _value = v ?? _value),
      items: const [
        AppRadioItem(value: 'a', label: 'Standard (3–5 days)'),
        AppRadioItem(value: 'b', label: 'Express (1–2 days)'),
        AppRadioItem(value: 'c', label: 'Same Day'),
      ],
    );
  }
}
