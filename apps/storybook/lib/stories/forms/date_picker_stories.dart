import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [AppDatePicker].
final List<WidgetbookUseCase> datePickerStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'Disabled', builder: _disabled),
];

Widget _default(BuildContext context) {
  final label = context.knobs.string(
    label: 'Label',
    initialValue: 'Date of birth',
  );
  final hint = context.knobs.string(
    label: 'Hint',
    initialValue: 'Select a date',
  );

  return SizedBox(
    width: 320,
    child: _DatePickerDemo(label: label, hint: hint),
  );
}

Widget _disabled(BuildContext context) {
  return SizedBox(
    width: 320,
    child: AppDatePicker(
      selectedDate: DateTime(1990, 6, 15),
      onDateSelected: (_) {},
      label: 'Date of birth',
      hint: 'Select a date',
      enabled: false,
    ),
  );
}

class _DatePickerDemo extends StatefulWidget {
  const _DatePickerDemo({
    this.label = 'Date of birth',
    this.hint = 'Select a date',
  });

  final String label;
  final String hint;

  @override
  State<_DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<_DatePickerDemo> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return AppDatePicker(
      selectedDate: _selectedDate,
      onDateSelected: (date) => setState(() => _selectedDate = date),
      label: widget.label,
      hint: widget.hint,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
}
