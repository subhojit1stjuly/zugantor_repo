import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSListTile].
final listTileStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) => ZDSListTile(
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Account Settings',
      ),
      subtitle: context.knobs.stringOrNull(
        label: 'Subtitle',
        initialValue: 'Manage your profile and security',
      ),
      isSelected: context.knobs.boolean(
        label: 'Selected',
        initialValue: false,
      ),
      enabled: context.knobs.boolean(
        label: 'Enabled',
        initialValue: true,
      ),
      leading: Icons.manage_accounts_outlined,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    ),
  ),
  WidgetbookUseCase(
    name: 'List of Items',
    builder: (context) => const SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZDSListTile(
            title: 'Profile',
            subtitle: 'Edit your personal information',
            leading: Icons.person_outlined,
            trailing: Icon(Icons.chevron_right),
          ),
          ZDSListTile(
            title: 'Notifications',
            subtitle: 'Push, email, and SMS alerts',
            leading: Icons.notifications_outlined,
            trailing: Icon(Icons.chevron_right),
          ),
          ZDSListTile(
            title: 'Privacy',
            leading: Icons.lock_outlined,
            trailing: Icon(Icons.chevron_right),
            isSelected: true,
          ),
          ZDSListTile(
            title: 'Help Center',
            leading: Icons.help_outline,
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
        ],
      ),
    ),
  ),
];
