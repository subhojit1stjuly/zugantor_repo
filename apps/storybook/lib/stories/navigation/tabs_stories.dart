import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSTabs].
final List<WidgetbookUseCase> tabsStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'With Icons', builder: _withIcons),
];

Widget _default(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSTabs(
      tabs: [
        ZDSTabItem(
          label: 'Overview',
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'General overview of the component and its usage.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
        ZDSTabItem(
          label: 'Details',
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Detailed configuration options and properties.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
        ZDSTabItem(
          label: 'History',
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Version history and changelog entries.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
        ZDSTabItem(
          label: 'Disabled',
          enabled: false,
          content: const SizedBox.shrink(),
        ),
      ],
    ),
  );
}

Widget _withIcons(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSTabs(
      tabs: [
        ZDSTabItem(
          label: 'Home',
          icon: Icons.home_outlined,
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Home tab content.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
        ZDSTabItem(
          label: 'Search',
          icon: Icons.search,
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Search tab content.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
        ZDSTabItem(
          label: 'Profile',
          icon: Icons.person_outline,
          content: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Profile tab content.',
              style: ZDSTheme.of(context).typography.bodyMedium,
            ),
          ),
        ),
      ],
    ),
  );
}
