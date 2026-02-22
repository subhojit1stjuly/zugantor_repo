import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [Section].
final sectionStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => Section(
      title: context.knobs.stringOrNull(
        label: 'Title',
        initialValue: 'Account Settings',
      ),
      subtitle: context.knobs.stringOrNull(
        label: 'Subtitle',
        initialValue: 'Manage your account preferences',
      ),
      showDivider: context.knobs.boolean(
        label: 'Show Divider',
        initialValue: false,
      ),
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    ),
  ),
  WidgetbookUseCase(
    name: 'With Actions',
    builder: (context) => Section(
      title: 'Recent Orders',
      actions: [
        TextButton(onPressed: () {}, child: const Text('View all')),
      ],
      child: const Text('Order list content goes here...'),
    ),
  ),
];
