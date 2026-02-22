import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppDatePicker].
final datePickerStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => _DatePickerDemo(
      label: context.knobs.stringOrNull(
        label: 'Label',
        initialValue: 'Date of birth',
      ),
      hint: context.knobs.string(
        label: 'Hint',
        initialValue: 'Select a date',
      ),
      enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    ),
  ),
];

class _DatePickerDemo extends StatefulWidget {
  const _DatePickerDemo({
    required this.label,
    required this.hint,
    required this.enabled,
  });

  final String? label;
  final String hint;
  final bool enabled;

  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: AppDatePicker(
        selectedDate: _selected,
        label: widget.label,
        hint: widget.hint,
        enabled: widget.enabled,
        onDateSelected: (d) => setState(() => _selected = d),
      ),
    );
  }
}
