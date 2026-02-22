import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSBadge].
final badgeStories = [
  WidgetbookUseCase(
    name: 'Dot Badge',
    builder: (context) => ZDSBadge(
      child: Icon(
        Icons.notifications_outlined,
        size: 32,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  ),
  WidgetbookUseCase(
    name: 'Count Badge',
    builder: (context) {
      final count = context.knobs.double
          .slider(
            label: 'Count',
            initialValue: 5,
            min: 0,
            max: 120,
            divisions: 120,
          )
          .round();
      final showWhenZero = context.knobs.boolean(
        label: 'Show When Zero',
        initialValue: false,
      );
      return ZDSBadge.count(
        count: count,
        showWhenZero: showWhenZero,
        child: Icon(
          Icons.shopping_cart_outlined,
          size: 32,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'On Navigation Icon',
    builder: (context) => const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ZDSBadge(child: Icon(Icons.mail_outlined, size: 28)),
        SizedBox(width: 24),
        ZDSBadge.count(
          count: 3,
          child: Icon(Icons.notifications_outlined, size: 28),
        ),
        SizedBox(width: 24),
        ZDSBadge.count(
          count: 99,
          child: Icon(Icons.chat_outlined, size: 28),
        ),
        SizedBox(width: 24),
        ZDSBadge.count(
          count: 100,
          child: Icon(Icons.inbox_outlined, size: 28),
        ),
      ],
    ),
  ),
];
