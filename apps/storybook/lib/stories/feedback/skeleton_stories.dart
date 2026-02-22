import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSSkeleton].
final skeletonStories = [
  WidgetbookUseCase(
    name: 'Rectangle',
    builder: (context) => ZDSSkeleton(
      width: context.knobs.double.slider(
        label: 'Width',
        initialValue: 200,
        min: 50,
        max: 400,
        divisions: 14,
      ),
      height: context.knobs.double.slider(
        label: 'Height',
        initialValue: 100,
        min: 20,
        max: 200,
        divisions: 18,
      ),
    ),
  ),
  WidgetbookUseCase(
    name: 'Text Lines',
    builder: (context) => const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZDSSkeleton.text(width: 240),
          SizedBox(height: 8),
          ZDSSkeleton.text(width: 180),
          SizedBox(height: 8),
          ZDSSkeleton.text(width: 210),
        ],
      ),
    ),
  ),
  WidgetbookUseCase(
    name: 'Circle',
    builder: (context) => ZDSSkeleton.circle(
      diameter: context.knobs.double.slider(
        label: 'Diameter',
        initialValue: 56,
        min: 24,
        max: 120,
        divisions: 12,
      ),
    ),
  ),
  WidgetbookUseCase(
    name: 'Card Placeholder',
    builder: (context) => const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ZDSSkeleton.circle(diameter: 48),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ZDSSkeleton.text(width: 140),
              SizedBox(height: 6),
              ZDSSkeleton.text(width: 100),
            ],
          ),
        ],
      ),
    ),
  ),
];
