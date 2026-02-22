import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Trend direction for [ZDSStatCard].
enum ZDSStatTrend {
  /// Value increased — shown in green with an up arrow.
  up,

  /// Value decreased — shown in red with a down arrow.
  down,

  /// No trend or flat change — shown neutrally.
  neutral,
}

/// A metric display card for dashboards and summary screens.
///
/// Shows a label, a primary value, and an optional trend indicator.
///
/// ```dart
/// ZDSStatCard(
///   label: 'Total Revenue',
///   value: '\$24,500',
///   trend: ZDSStatTrend.up,
///   trendLabel: '+12% vs last month',
///   icon: Icons.attach_money,
/// )
/// ```
class ZDSStatCard extends StatelessWidget {
  /// Creates a stat card.
  const ZDSStatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend = ZDSStatTrend.neutral,
    this.trendLabel,
    this.icon,
    this.onTap,
  });

  /// Short descriptor of the metric (e.g. 'Monthly Sales').
  final String label;

  /// The primary metric value to display (e.g. '\$12,400', '98%').
  final String value;

  /// The trend direction for the current period.
  final ZDSStatTrend trend;

  /// Human-readable trend description (e.g. '+5.2% vs last week').
  final String? trendLabel;

  /// Optional icon shown in the top-right corner.
  final IconData? icon;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: theme.shapes.mediumRadius,
      child: Container(
        padding: EdgeInsets.all(theme.spacing.m),
        decoration: BoxDecoration(
          color: theme.colors.surface,
          borderRadius: theme.shapes.mediumRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.typography.labelMedium
                        ?.copyWith(color: theme.colors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: theme.spacing.s),
                  Icon(icon, size: 20, color: theme.colors.primary),
                ],
              ],
            ),
            SizedBox(height: theme.spacing.xs),
            Text(
              value,
              style: theme.typography.headlineSmall
                  ?.copyWith(color: theme.colors.textPrimary),
            ),
            if (trendLabel != null) ...[
              SizedBox(height: theme.spacing.xxs),
              _TrendRow(
                trend: trend,
                label: trendLabel!,
                theme: theme,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.trend,
    required this.label,
    required this.theme,
  });

  final ZDSStatTrend trend;
  final String label;
  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (trend) {
      ZDSStatTrend.up => (Icons.trending_up, theme.colors.success),
      ZDSStatTrend.down => (Icons.trending_down, theme.colors.error),
      ZDSStatTrend.neutral => (Icons.trending_flat, theme.colors.textTertiary),
    };

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: theme.spacing.xxs),
        Expanded(
          child: Text(
            label,
            style: theme.typography.labelSmall?.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
