import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSAppBar].
final appBarStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final title = context.knobs.string(
        label: 'Title',
        initialValue: 'Dashboard',
      );
      final centerTitle = context.knobs.boolean(
        label: 'Center Title',
        initialValue: true,
      );
      final showActions = context.knobs.boolean(
        label: 'Show Actions',
        initialValue: true,
      );
      final showLeading = context.knobs.boolean(
        label: 'Show Leading',
        initialValue: false,
      );
      return SizedBox(
        height: kToolbarHeight,
        child: ZDSAppBar(
          title: title,
          centerTitle: centerTitle,
          leading: showLeading ? const BackButton() : null,
          actions: showActions
              ? [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ]
              : null,
        ),
      );
    },
  ),
];
