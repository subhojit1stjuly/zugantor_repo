import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

import 'stories/buttons/button_stories.dart';
import 'stories/data_display/badge_stories.dart';
import 'stories/data_display/chip_stories.dart';
import 'stories/data_display/list_tile_stories.dart';
import 'stories/data_display/stat_card_stories.dart';
import 'stories/feedback/progress_indicator_stories.dart';
import 'stories/feedback/skeleton_stories.dart';
import 'stories/forms/checkbox_stories.dart';
import 'stories/forms/date_picker_stories.dart';
import 'stories/forms/dropdown_stories.dart';
import 'stories/forms/radio_stories.dart';
import 'stories/forms/switch_stories.dart';
import 'stories/forms/text_input_stories.dart';
import 'stories/layout/card_stories.dart';
import 'stories/layout/section_stories.dart';
import 'stories/navigation/app_bar_stories.dart';
import 'stories/navigation/navigation_bar_stories.dart';
import 'stories/theme/color_stories.dart';
import 'stories/theme/typography_stories.dart';

void main() => runApp(const WidgetbookApp());

/// Root widget for the Zugantor Design System component explorer.
///
/// Powered by [Widgetbook](https://pub.dev/packages/widgetbook), this app
/// provides isolated stories, live knobs, theme switching, and viewport
/// simulation for every ZDS component.
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ZDSThemeFactory.light()),
            WidgetbookTheme(name: 'Dark', data: ZDSThemeFactory.dark()),
          ],
        ),
        TextScaleAddon(min: 0.75, max: 2.0, divisions: 5),
        AlignmentAddon(initialAlignment: Alignment.center),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Foundation',
          children: [
            WidgetbookComponent(
              name: 'Colors',
              useCases: colorStories,
            ),
            WidgetbookComponent(
              name: 'Typography',
              useCases: typographyStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Buttons',
          children: [
            WidgetbookComponent(
              name: 'ZDSButton',
              useCases: buttonStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Forms',
          children: [
            WidgetbookComponent(
              name: 'AppTextInput',
              useCases: textInputStories,
            ),
            WidgetbookComponent(
              name: 'AppCheckbox',
              useCases: checkboxStories,
            ),
            WidgetbookComponent(
              name: 'AppRadioGroup',
              useCases: radioStories,
            ),
            WidgetbookComponent(
              name: 'AppSwitch',
              useCases: switchStories,
            ),
            WidgetbookComponent(
              name: 'AppDropdown',
              useCases: dropdownStories,
            ),
            WidgetbookComponent(
              name: 'AppDatePicker',
              useCases: datePickerStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Layout',
          children: [
            WidgetbookComponent(
              name: 'AppCard',
              useCases: cardStories,
            ),
            WidgetbookComponent(
              name: 'Section',
              useCases: sectionStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Feedback',
          children: [
            WidgetbookComponent(
              name: 'ZDSProgressIndicator',
              useCases: progressIndicatorStories,
            ),
            WidgetbookComponent(
              name: 'ZDSSkeleton',
              useCases: skeletonStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Navigation',
          children: [
            WidgetbookComponent(
              name: 'ZDSAppBar',
              useCases: appBarStories,
            ),
            WidgetbookComponent(
              name: 'ZDSNavigationBar',
              useCases: navigationBarStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Data Display',
          children: [
            WidgetbookComponent(
              name: 'ZDSChip',
              useCases: chipStories,
            ),
            WidgetbookComponent(
              name: 'ZDSBadge',
              useCases: badgeStories,
            ),
            WidgetbookComponent(
              name: 'ZDSListTile',
              useCases: listTileStories,
            ),
            WidgetbookComponent(
              name: 'ZDSStatCard',
              useCases: statCardStories,
            ),
          ],
        ),
      ],
    );
  }
}
