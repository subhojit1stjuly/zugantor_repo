import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A single item in an [ZDSAccordion].
class ZDSAccordionItem {
  /// Creates an ZDSAccordion item.
  const ZDSAccordionItem({
    required this.title,
    required this.content,
    this.subtitle,
    this.initiallyExpanded = false,
  });

  /// The header title of the ZDSAccordion panel.
  final String title;

  /// The widget displayed when the panel is expanded.
  final Widget content;

  /// Optional secondary text below the title.
  final String? subtitle;

  /// Whether this panel starts in an expanded state.
  final bool initiallyExpanded;
}

/// A theme-aware ZDSAccordion component for the ZDS design system.
///
/// An ZDSAccordion is a vertically stacked set of expandable/collapsible panels.
/// It follows the **ZDSAccordion** component pattern documented at
/// [component.gallery](https://component.gallery/components/ZDSAccordion/).
///
/// Example:
/// ```dart
/// ZDSAccordion(
///   items: [
///     ZDSAccordionItem(
///       title: 'What is a design system?',
///       content: Text('A design system is a collection of reusable components...'),
///     ),
///     ZDSAccordionItem(
///       title: 'How do I contribute?',
///       content: Text('Open a pull request on GitHub...'),
///     ),
///   ],
/// )
/// ```
class ZDSAccordion extends StatefulWidget {
  /// Creates an ZDSAccordion.
  ZDSAccordion({
    super.key,
    required this.items,
    this.allowMultiple = false,
  }) : assert(items.isNotEmpty, 'ZDSAccordion requires at least one item.');

  /// The list of ZDSAccordion panels to display.
  final List<ZDSAccordionItem> items;

  /// When [allowMultiple] is false (the default), expanding one panel will
  /// collapse all others. When true, multiple panels can be open at once.
  final bool allowMultiple;

  @override
  State<ZDSAccordion> createState() => _AccordionState();
}

class _AccordionState extends State<ZDSAccordion> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.items.map((item) => item.initiallyExpanded).toList();
  }

  void _toggle(int index) {
    setState(() {
      if (widget.allowMultiple) {
        _expanded[index] = !_expanded[index];
      } else {
        final isCurrentlyExpanded = _expanded[index];
        _expanded = List.filled(widget.items.length, false);
        _expanded[index] = !isCurrentlyExpanded;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Column(
      children: List.generate(
        widget.items.length,
        (i) => _AccordionPanel(
          item: widget.items[i],
          isExpanded: _expanded[i],
          onToggle: () => _toggle(i),
          isLast: i == widget.items.length - 1,
          theme: theme,
        ),
      ),
    );
  }
}

class _AccordionPanel extends StatelessWidget {
  const _AccordionPanel({
    required this.item,
    required this.isExpanded,
    required this.onToggle,
    required this.isLast,
    required this.theme,
  });

  final ZDSAccordionItem item;
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool isLast;
  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    final borderColor = theme.colors.border ?? Colors.grey.shade300;
    final activeColor = theme.colors.primary ?? Colors.blue;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: isLast ? BorderSide(color: borderColor) : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.m,
                vertical: theme.spacing.m,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.typography.titleSmall?.copyWith(
                            color: isExpanded ? activeColor : null,
                            fontWeight: isExpanded
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          SizedBox(height: theme.spacing.xxs),
                          Text(
                            item.subtitle!,
                            style: theme.typography.bodySmall?.copyWith(
                              color: theme.colors.onSurface
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isExpanded ? activeColor : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: theme.spacing.m,
                right: theme.spacing.m,
                bottom: theme.spacing.m,
              ),
              child: item.content,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
