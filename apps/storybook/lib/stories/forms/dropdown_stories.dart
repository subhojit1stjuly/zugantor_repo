import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSDropdown].
final List<WidgetbookUseCase> dropdownStories = [
  WidgetbookUseCase(name: 'Countries', builder: _countries),
  WidgetbookUseCase(name: 'Disabled', builder: _disabled),
];

const _countryItems = [
  ZDSDropdownItem(value: 'us', label: 'United States'),
  ZDSDropdownItem(value: 'uk', label: 'United Kingdom'),
  ZDSDropdownItem(value: 'ca', label: 'Canada'),
  ZDSDropdownItem(value: 'au', label: 'Australia'),
  ZDSDropdownItem(value: 'de', label: 'Germany'),
];

Widget _countries(BuildContext context) {
  final label = context.knobs.string(label: 'Label', initialValue: 'Country');
  final hint = context.knobs.string(
    label: 'Hint',
    initialValue: 'Select a country...',
  );

  return SizedBox(
    width: 320,
    child: _DropdownDemo(label: label, hint: hint),
  );
}

Widget _disabled(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: ZDSDropdown<String>(
      value: 'us',
      label: 'Country',
      hint: 'Select a country...',
      enabled: false,
      items: _countryItems,
      onChanged: null,
    ),
  );
}

class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo({
    this.label = 'Country',
    this.hint = 'Select a country...',
  });

  final String label;
  final String hint;

  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return ZDSDropdown<String>(
      value: _value,
      label: widget.label,
      hint: widget.hint,
      items: _countryItems,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}
