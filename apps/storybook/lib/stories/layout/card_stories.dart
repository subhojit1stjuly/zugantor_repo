import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [AppCard].
final cardStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final elevationIndex = context.knobs.int.slider(
        label: 'Elevation (0=low 1=medium 2=high)',
        initialValue: 0,
        min: 0,
        max: CardElevation.values.length - 1,
        divisions: CardElevation.values.length - 1,
      );
      final elevation = CardElevation.values[elevationIndex];
      final tappable = context.knobs.boolean(
        label: 'Tappable',
        initialValue: false,
      );
      return Padding(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          elevation: elevation,
          onTap: tappable ? () {} : null,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Card Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This is the card body. Cards group related content '
                'with consistent elevation and padding.',
              ),
            ],
          ),
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'All Elevations',
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: CardElevation.values
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppCard(
                  elevation: e,
                  child: Text(
                    e.name[0].toUpperCase() + e.name.substring(1),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ),
  ),
];
