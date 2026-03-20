import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Use-cases for [ZDSSection].
final List<WidgetbookUseCase> sectionStories = [
  WidgetbookUseCase(name: 'Default', builder: _default),
  WidgetbookUseCase(name: 'With Actions', builder: _withActions),
];

Widget _default(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Account settings',
  );
  final subtitle = context.knobs.stringOrNull(
    label: 'Subtitle',
    initialValue: 'Manage your profile and preferences',
  );
  final showDivider = context.knobs.boolean(
    label: 'Show divider',
    initialValue: false,
  );

  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSSection(
      title: title,
      subtitle: subtitle,
      showDivider: showDivider,
      child: Text(
        'ZDSSection body content appears here. It can be any widget.',
        style: ZDSTheme.of(context).typography.bodyMedium,
      ),
    ),
  );
}

Widget _withActions(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ZDSSection(
      title: 'Members',
      subtitle: '3 active members',
      showDivider: true,
      actions: [
        ZDSButton.icon(
          icon: Icons.person_add,
          onPressed: () {},
          tooltip: 'Add member',
        ),
        ZDSButton.icon(
          icon: Icons.settings,
          onPressed: () {},
          tooltip: 'Settings',
        ),
      ],
      child: const _MemberList(),
    ),
  );
}

class _MemberList extends StatelessWidget {
  const _MemberList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ['Alice', 'Bob', 'Charlie'].map((name) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(name),
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
