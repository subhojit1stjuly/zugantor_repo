import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [Alert].
final List<WidgetbookUseCase> alertStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'All Variants', builder: _allVariants),
  WidgetbookUseCase(name: 'Dismissible', builder: _dismissible),
];

Widget _default(BuildContext context) {
  final variantIndex = context.knobs.int.slider(
    label: 'Variant (0=info, 1=success, 2=warning, 3=error)',
    initialValue: 0,
    min: 0,
    max: 3,
    divisions: 3,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Alert title',
  );
  final message = context.knobs.string(
    label: 'Message',
    initialValue: 'This is the alert message body.',
  );

  final variants = [
    AlertVariant.info,
    AlertVariant.success,
    AlertVariant.warning,
    AlertVariant.error,
  ];

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Alert(
      variant: variants[variantIndex],
      title: title,
      message: message,
    ),
  );
}

Widget _allVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Alert.info(title: 'Info', message: 'Here is some helpful information.'),
        SizedBox(height: 8),
        Alert.success(
          title: 'Success',
          message: 'Your changes have been saved successfully.',
        ),
        SizedBox(height: 8),
        Alert.warning(
          title: 'Warning',
          message: 'Please review before continuing.',
        ),
        SizedBox(height: 8),
        Alert.error(
          title: 'Error',
          message: 'Something went wrong. Please try again.',
        ),
      ],
    ),
  );
}

Widget _dismissible(BuildContext context) {
  return Padding(padding: const EdgeInsets.all(16), child: _DismissibleAlert());
}

class _DismissibleAlert extends StatefulWidget {
  @override
  State<_DismissibleAlert> createState() => _DismissibleAlertState();
}

class _DismissibleAlertState extends State<_DismissibleAlert> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return Center(
        child: TextButton(
          onPressed: () => setState(() => _visible = true),
          child: const Text('Show alert again'),
        ),
      );
    }

    return Alert.info(
      title: 'Dismissible alert',
      message: 'Tap the close button to dismiss this alert.',
      onClose: () => setState(() => _visible = false),
    );
  }
}
