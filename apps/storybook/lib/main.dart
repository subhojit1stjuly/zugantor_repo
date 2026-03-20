import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

import 'stories/buttons/button_stories.dart';
import 'stories/display/badge_stories.dart';
import 'stories/feedback/alert_stories.dart';
import 'stories/forms/checkbox_stories.dart';
import 'stories/forms/date_picker_stories.dart';
import 'stories/forms/dropdown_stories.dart';
import 'stories/forms/radio_stories.dart';
import 'stories/forms/switch_stories.dart';
import 'stories/forms/text_input_stories.dart';
import 'stories/foundation/color_stories.dart';
import 'stories/foundation/typography_stories.dart';
import 'stories/layout/card_stories.dart';
import 'stories/layout/section_stories.dart';
import 'stories/navigation/accordion_stories.dart';
import 'stories/navigation/tabs_stories.dart';

void main() => runApp(const WidgetbookApp());

/// Root widget for the Zugantor Design System component explorer.
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
            WidgetbookComponent(name: 'Colors', useCases: colorStories),
            WidgetbookComponent(
              name: 'Typography',
              useCases: typographyStories,
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Buttons',
          children: [
            WidgetbookComponent(name: 'ZDSButton', useCases: buttonStories),
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
            WidgetbookComponent(name: 'AppSwitch', useCases: switchStories),
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
            WidgetbookComponent(name: 'AppCard', useCases: cardStories),
            WidgetbookComponent(name: 'Section', useCases: sectionStories),
          ],
        ),
        WidgetbookCategory(
          name: 'Feedback',
          children: [
            WidgetbookComponent(name: 'Alert', useCases: alertStories),
          ],
        ),
        WidgetbookCategory(
          name: 'Navigation',
          children: [
            WidgetbookComponent(
              name: 'Accordion',
              useCases: accordionStories,
            ),
            WidgetbookComponent(name: 'ZDSTabs', useCases: tabsStories),
          ],
        ),
        WidgetbookCategory(
          name: 'Display',
          children: [
            WidgetbookComponent(name: 'ZDSBadge', useCases: badgeStories),
          ],
        ),
      ],
    );
  }
}
