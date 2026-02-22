import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

/// Stories for [ZDSStatCard].
final statCardStories = [
  WidgetbookUseCase(
    name: 'Default',
    builder: (context) {
      final trendIndex = context.knobs.int.slider(
        label: 'Trend (0=up 1=down 2=neutral)',
        initialValue: 0,
        min: 0,
        max: ZDSStatTrend.values.length - 1,
        divisions: ZDSStatTrend.values.length - 1,
      );
      return SizedBox(
        width: 240,
        child: ZDSStatCard(
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Monthly Revenue',
          ),
          value: context.knobs.string(
            label: 'Value',
            initialValue: '\$24,500',
          ),
          trend: ZDSStatTrend.values[trendIndex],
          trendLabel: context.knobs.stringOrNull(
            label: 'Trend Label',
            initialValue: '+12% vs last month',
          ),
          icon: Icons.attach_money,
          onTap: () {},
        ),
      );
    },
  ),
  WidgetbookUseCase(
    name: 'Dashboard Grid',
    builder: (context) => const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 200,
          child: ZDSStatCard(
            label: 'Total Orders',
            value: '1,284',
            trend: ZDSStatTrend.up,
            trendLabel: '+8% this week',
            icon: Icons.shopping_bag_outlined,
          ),
        ),
        SizedBox(
          width: 200,
          child: ZDSStatCard(
            label: 'Revenue',
            value: '\$48,200',
            trend: ZDSStatTrend.up,
            trendLabel: '+14% this month',
            icon: Icons.attach_money,
          ),
        ),
        SizedBox(
          width: 200,
          child: ZDSStatCard(
            label: 'Returns',
            value: '42',
            trend: ZDSStatTrend.down,
            trendLabel: '-3% vs last week',
            icon: Icons.assignment_return_outlined,
          ),
        ),
        SizedBox(
          width: 200,
          child: ZDSStatCard(
            label: 'Active Users',
            value: '9,830',
            trend: ZDSStatTrend.neutral,
            trendLabel: 'No change',
            icon: Icons.people_outlined,
          ),
        ),
      ],
    ),
  ),
];
