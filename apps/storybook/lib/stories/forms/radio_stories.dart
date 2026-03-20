import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [AppRadioGroup].
final List<WidgetbookUseCase> radioStories = [
  WidgetbookUseCase(name: 'Shipping Method', builder: _shippingMethod),
  WidgetbookUseCase(name: 'Horizontal', builder: _horizontal),
];

const _shippingItems = [
  AppRadioItem(value: 'standard', label: 'Standard (3–5 days)'),
  AppRadioItem(value: 'express', label: 'Express (1–2 days)'),
  AppRadioItem(value: 'overnight', label: 'Overnight'),
];

Widget _shippingMethod(BuildContext context) {
  final enabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

  return _RadioDemo(
    label: 'Shipping method',
    items: _shippingItems,
    enabled: enabled,
  );
}

Widget _horizontal(BuildContext context) {
  return _RadioDemo(
    label: 'Size',
    items: const [
      AppRadioItem(value: 's', label: 'S'),
      AppRadioItem(value: 'm', label: 'M'),
      AppRadioItem(value: 'l', label: 'L'),
      AppRadioItem(value: 'xl', label: 'XL'),
    ],
    direction: Axis.horizontal,
  );
}

class _RadioDemo extends StatefulWidget {
  const _RadioDemo({
    required this.label,
    required this.items,
    this.enabled = true,
    this.direction = Axis.vertical,
  });

  final String label;
  final List<AppRadioItem<String>> items;
  final bool enabled;
  final Axis direction;

  @override
  State<_RadioDemo> createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppRadioGroup<String>(
        value: _value,
        onChanged: widget.enabled ? (v) => setState(() => _value = v) : null,
        label: widget.label,
        items: widget.items,
        enabled: widget.enabled,
        direction: widget.direction,
      ),
    );
  }
}
