import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSAccordion].
final List<WidgetbookUseCase> accordionStories = [
  WidgetbookUseCase(name: 'FAQ', builder: _faq),
  WidgetbookUseCase(name: 'Allow Multiple', builder: _allowMultiple),
];

Widget _faq(BuildContext context) {
  final allowMultiple = context.knobs.boolean(
    label: 'Allow multiple open',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSAccordion(
      allowMultiple: allowMultiple,
      items: [
        ZDSAccordionItem(
          title: 'What is the Zugantor Design System?',
          subtitle: 'Overview',
          initiallyExpanded: true,
          content: Text(
            'ZDS is a versatile, themeable Flutter design system with '
            'components aligned with standard accessibility patterns.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
        ZDSAccordionItem(
          title: 'Which platforms are supported?',
          content: Text(
            'ZDS supports iOS, Android, Web, macOS, Windows, and Linux.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
        ZDSAccordionItem(
          title: 'How do I contribute?',
          content: Text(
            'Open a pull request on GitHub and follow the contribution '
            'guidelines in the repository README.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
      ],
    ),
  );
}

Widget _allowMultiple(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSAccordion(
      allowMultiple: true,
      items: [
        ZDSAccordionItem(
          title: 'Section A',
          initiallyExpanded: true,
          content: Text(
            'Content for Section A.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
        ZDSAccordionItem(
          title: 'Section B',
          initiallyExpanded: true,
          content: Text(
            'Content for Section B.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
        ZDSAccordionItem(
          title: 'Section C',
          content: Text(
            'Content for Section C.',
            style: ZDSTheme.of(context).typography.bodyMedium,
          ),
        ),
      ],
    ),
  );
}
