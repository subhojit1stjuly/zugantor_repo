import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

final _options = [
  const AppDropdownItem(value: 'au', label: 'Australia'),
  const AppDropdownItem(value: 'ca', label: 'Canada'),
  const AppDropdownItem(value: 'de', label: 'Germany'),
  const AppDropdownItem(value: 'gb', label: 'United Kingdom'),
  const AppDropdownItem(value: 'us', label: 'United States'),
];

/// Stories for [AppDropdown].
final dropdownStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => _DropdownDemo(
      label: context.knobs.stringOrNull(
        label: 'Label',
        initialValue: 'Country',
      ),
      hint: context.knobs.string(
        label: 'Hint',
        initialValue: 'Select a country',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  ),
];

class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo({
    required this.label,
    required this.hint,
    required this.enabled,
  });

  final String? label;
  final String hint;
  final bool enabled;

  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AppDropdown<String>(
        value: _selected,
        label: widget.label,
        hint: widget.hint,
        enabled: widget.enabled,
        items: _options,
        onChanged: (v) => setState(() => _selected = v),
      ),
    );
  }
}
