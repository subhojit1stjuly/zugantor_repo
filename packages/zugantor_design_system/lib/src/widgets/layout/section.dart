import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A widget for grouping related content with consistent styling.
///
/// Sections are used to organize content hierarchically and provide
/// visual separation between different areas of the UI.
class Section extends StatelessWidget {
  /// Creates a section.
  const Section({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding,
    this.showDivider = false,
    this.actions,
  });

  /// Optional title for the section.
  final String? title;

  /// Optional subtitle or description for the section.
  final String? subtitle;

  /// The content of the section.
  final Widget child;

  /// Optional padding around the section. Defaults to medium padding.
  final EdgeInsetsGeometry? padding;

  /// Whether to show a divider at the bottom of the section.
  final bool showDivider;

  /// Optional action widgets displayed in the header (e.g., buttons, icons).
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Container(
      padding: padding ?? EdgeInsets.all(theme.spacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (title != null || subtitle != null || actions != null)
            _buildHeader(context, theme),

          // Spacing between header and content
          if (title != null || subtitle != null)
            SizedBox(height: theme.spacing.m),

          // Content
          child,

          // Optional divider at the bottom
          if (showDivider) ...[
            SizedBox(height: theme.spacing.m),
            Divider(
              color: theme.colors.divider,
              thickness: 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ZDSTheme theme) {
    final hasActions = actions != null && actions!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: theme.typography.titleLarge,
                ),
              if (subtitle != null) ...[
                SizedBox(height: theme.spacing.xs),
                Text(
                  subtitle!,
                  style: theme.typography.bodyMedium?.copyWith(
                    color: theme.colors.onSurface?.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Actions
        if (hasActions) ...[
          SizedBox(width: theme.spacing.m),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ),
        ],
      ],
    );
  }
}

/// A vertical list of sections with consistent spacing.
///
/// This widget makes it easy to build scrollable lists of sections
/// with proper spacing between them.
class SectionList extends StatelessWidget {
  /// Creates a section list.
  const SectionList({
    super.key,
    required this.sections,
    this.spacing,
    this.padding,
  });

  /// The sections to display.
  final List<Widget> sections;

  /// Spacing between sections. Defaults to large spacing.
  final double? spacing;

  /// Padding around the entire list.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final effectiveSpacing = spacing ?? theme.spacing.l;

    return ListView.separated(
      padding: padding ?? EdgeInsets.all(theme.spacing.m),
      itemCount: sections.length,
      separatorBuilder: (context, index) => SizedBox(height: effectiveSpacing),
      itemBuilder: (context, index) => sections[index],
    );
  }
}
