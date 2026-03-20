import 'package:flutter/material.dart';
import 'package:zugantor_design_system/zugantor_design_system.dart';

void main() {
  runApp(const StorybookApp());
}

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZDS Storybook',
      theme: ZDSThemeFactory.light(),
      darkTheme: ZDSThemeFactory.dark(),
      themeMode: ThemeMode.system,
      home: const StorybookHome(),
    );
  }
}

class StorybookHome extends StatefulWidget {
  const StorybookHome({super.key});

  @override
  State<StorybookHome> createState() => _StorybookHomeState();
}

class _StorybookHomeState extends State<StorybookHome> {
  bool _checkboxValue = false;
  String _radioValue = 'option1';
  bool _switchValue = false;
  String? _dropdownValue;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    // ✨ Using new context extensions for cleaner code!

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ZDS Storybook',
          style: TextStyle(color: context.colors.onPrimary),
        ),
        backgroundColor: context.colors.primary,
        actions: [
          // Demonstrating responsive extension
          if (context.isDesktop)
            Padding(
              padding: EdgeInsets.only(right: context.spacing.m),
              child: Center(
                child: Text(
                  'Desktop Mode',
                  style: TextStyle(color: context.colors.onPrimary),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          context.responsive(
            mobile: context.spacing.m,
            tablet: context.spacing.l,
            desktop: context.spacing.xl,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context Extensions Info Card
            Container(
              padding: EdgeInsets.all(context.spacing.l),
              decoration: BoxDecoration(
                color: context.colors.info?.withOpacity(0.1),
                border: Border.all(color: context.colors.info ?? Colors.blue),
                borderRadius: context.shapes.smallRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: context.colors.info),
                      SizedBox(width: context.spacing.s),
                      Text(
                        '✨ New: Context Extensions Enabled!',
                        style: context.typography.titleMedium?.copyWith(
                          color: context.colors.info,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing.s),
                  Text(
                    'This page now uses context extensions for cleaner code. '
                    'Compare: theme.colors.primary → context.colors.primary',
                    style: context.typography.bodyMedium,
                  ),
                  SizedBox(height: context.spacing.xs),
                  Text(
                    'Screen: ${context.screenWidth.toInt()}px • '
                    'Device: ${context.isMobile
                        ? "Mobile"
                        : context.isTablet
                        ? "Tablet"
                        : "Desktop"}',
                    style: context.typography.bodySmall?.copyWith(
                      color: context.colors.onSurface?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.spacing.xl),

            // Buttons Section
            Text('Buttons', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Wrap(
              spacing: context.spacing.m,
              runSpacing: context.spacing.s,
              children: [
                ZDSButton.primary(
                  onPressed: () => _showSnackBar(context, 'Primary pressed!'),
                  label: 'Primary',
                ),
                ZDSButton.secondary(
                  onPressed: () => _showSnackBar(context, 'Secondary pressed!'),
                  label: 'Secondary',
                ),
                ZDSButton.text(
                  onPressed: () => _showSnackBar(context, 'Text pressed!'),
                  label: 'Text Button',
                ),
                ZDSButton.primary(onPressed: null, label: 'Disabled'),
              ],
            ),
            SizedBox(height: context.spacing.m),
            Row(
              children: [
                ZDSButton.icon(
                  onPressed: () => _showSnackBar(context, 'Heart pressed!'),
                  icon: Icons.favorite,
                  tooltip: 'Favorite',
                ),
                ZDSButton.icon(
                  onPressed: () => _showSnackBar(context, 'Share pressed!'),
                  icon: Icons.share,
                  tooltip: 'Share',
                ),
                ZDSButton.icon(
                  onPressed: null,
                  icon: Icons.block,
                  tooltip: 'Disabled',
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Text Inputs Section
            Text('Text Inputs', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            AppTextInput(
              label: 'Normal Input',
              hint: 'Enter some text',
              helperText: 'This is a helper text',
              onChanged: (value) {},
            ),
            SizedBox(height: context.spacing.m),
            AppTextInput(
              label: 'Success Input',
              state: TextInputState.success,
              prefixIcon: Icons.check_circle,
              onChanged: (value) {},
            ),
            SizedBox(height: context.spacing.m),
            AppTextInput(
              label: 'Warning Input',
              state: TextInputState.warning,
              prefixIcon: Icons.warning,
              onChanged: (value) {},
            ),
            SizedBox(height: context.spacing.m),
            AppTextInput(
              label: 'Error Input',
              state: TextInputState.error,
              errorText: 'This field is required',
              prefixIcon: Icons.error,
              onChanged: (value) {},
            ),
            SizedBox(height: context.spacing.m),
            AppTextInput(
              label: 'Disabled Input',
              enabled: false,
              onChanged: (value) {},
            ),

            SizedBox(height: context.spacing.xl),

            // Cards Section
            Text('Cards', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            AppCard(
              elevation: CardElevation.low,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Low Elevation Card',
                    style: context.typography.titleMedium,
                  ),
                  SizedBox(height: context.spacing.s),
                  Text(
                    'This card has low elevation for subtle grouping.',
                    style: context.typography.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.m),
            AppCard(
              elevation: CardElevation.medium,
              onTap: () => _showSnackBar(context, 'Card tapped!'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive Card',
                    style: context.typography.titleMedium,
                  ),
                  SizedBox(height: context.spacing.s),
                  Text(
                    'This card is tappable with medium elevation.',
                    style: context.typography.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing.m),
            AppCard(
              elevation: CardElevation.high,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'High Elevation Card',
                    style: context.typography.titleMedium,
                  ),
                  SizedBox(height: context.spacing.s),
                  Text(
                    'This card has high elevation for emphasis.',
                    style: context.typography.bodyMedium,
                  ),
                ],
              ),
            ),

            SizedBox(height: context.spacing.xl),

            // Form Components Section
            Text('Form Components', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),

            // Checkboxes
            Text('Checkboxes', style: context.typography.titleMedium),
            SizedBox(height: context.spacing.s),
            AppCheckbox(
              value: _checkboxValue,
              onChanged: (value) =>
                  setState(() => _checkboxValue = value ?? false),
              label: 'I agree to the terms and conditions',
            ),
            AppCheckbox(
              value: false,
              onChanged: null,
              label: 'Disabled checkbox',
              enabled: false,
            ),

            SizedBox(height: context.spacing.m),

            // Radio Buttons
            Text('Radio Buttons', style: context.typography.titleMedium),
            SizedBox(height: context.spacing.s),
            AppRadioGroup<String>(
              value: _radioValue,
              onChanged: (value) =>
                  setState(() => _radioValue = value ?? 'option1'),
              label: 'Choose an option',
              items: const [
                AppRadioItem(value: 'option1', label: 'Option 1'),
                AppRadioItem(value: 'option2', label: 'Option 2'),
                AppRadioItem(value: 'option3', label: 'Option 3'),
              ],
            ),

            SizedBox(height: context.spacing.m),

            // Switches
            Text('Switches', style: context.typography.titleMedium),
            SizedBox(height: context.spacing.s),
            AppSwitch(
              value: _switchValue,
              onChanged: (value) => setState(() => _switchValue = value),
              label: 'Enable notifications',
            ),
            AppSwitch(
              value: false,
              onChanged: null,
              label: 'Disabled switch',
              enabled: false,
            ),

            SizedBox(height: context.spacing.m),

            // Dropdown
            Text('Dropdown', style: context.typography.titleMedium),
            SizedBox(height: context.spacing.s),
            AppDropdown<String>(
              value: _dropdownValue,
              onChanged: (value) => setState(() => _dropdownValue = value),
              label: 'Select a country',
              hint: 'Choose...',
              items: const [
                AppDropdownItem(value: 'us', label: 'United States'),
                AppDropdownItem(value: 'uk', label: 'United Kingdom'),
                AppDropdownItem(value: 'ca', label: 'Canada'),
                AppDropdownItem(value: 'au', label: 'Australia'),
              ],
            ),

            SizedBox(height: context.spacing.m),

            // Date Picker
            Text('Date Picker', style: context.typography.titleMedium),
            SizedBox(height: context.spacing.s),
            AppDatePicker(
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
              label: 'Birth Date',
              hint: 'Select your birth date',
            ),

            SizedBox(height: context.spacing.xl),

            // Alert Section
            Text('Alerts', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            const Alert.info(
              title: 'Informational',
              message:
                  'Here is some useful context about the current state.',
            ),
            SizedBox(height: context.spacing.s),
            const Alert.success(
              title: 'Profile saved',
              message: 'Your changes have been saved successfully.',
            ),
            SizedBox(height: context.spacing.s),
            const Alert.warning(
              title: 'Unsaved changes',
              message: 'You have unsaved changes. Please save before leaving.',
            ),
            SizedBox(height: context.spacing.s),
            Alert.error(
              title: 'Something went wrong',
              message: 'An unexpected error occurred. Please try again.',
              onClose: () => _showSnackBar(context, 'Alert dismissed'),
            ),

            SizedBox(height: context.spacing.xl),

            // Accordion Section
            Text('Accordion', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Accordion(
              items: [
                AccordionItem(
                  title: 'What is the Zugantor Design System?',
                  subtitle: 'Overview',
                  initiallyExpanded: true,
                  content: Text(
                    'ZDS is a versatile, themeable Flutter design system '
                    'aligned with standard component patterns from '
                    'component.gallery.',
                    style: context.typography.bodyMedium,
                  ),
                ),
                AccordionItem(
                  title: 'Which components are available?',
                  content: Text(
                    'Buttons, Cards, Form fields, Tabs, Alerts, Badges, '
                    'and Accordions – with more on the way.',
                    style: context.typography.bodyMedium,
                  ),
                ),
                AccordionItem(
                  title: 'How do I contribute?',
                  content: Text(
                    'Open a pull request on GitHub and follow the '
                    'contribution guidelines in the repository.',
                    style: context.typography.bodyMedium,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Tabs Section
            Text('Tabs', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            ZDSTabs(
              tabs: [
                ZDSTabItem(
                  label: 'Overview',
                  icon: Icons.info_outline,
                  content: Padding(
                    padding: EdgeInsets.only(top: context.spacing.m),
                    child: Text(
                      'This is the overview tab content.',
                      style: context.typography.bodyMedium,
                    ),
                  ),
                ),
                ZDSTabItem(
                  label: 'Details',
                  icon: Icons.list_alt,
                  content: Padding(
                    padding: EdgeInsets.only(top: context.spacing.m),
                    child: Text(
                      'Detailed information is shown here.',
                      style: context.typography.bodyMedium,
                    ),
                  ),
                ),
                ZDSTabItem(
                  label: 'Disabled',
                  enabled: false,
                  content: const SizedBox.shrink(),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Badge Section
            Text('Badges', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Wrap(
              spacing: context.spacing.m,
              runSpacing: context.spacing.m,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const ZDSBadge(label: 'Filled'),
                const ZDSBadge(
                  label: 'Outlined',
                  variant: BadgeVariant.outlined,
                ),
                const ZDSBadge(label: 'Soft', variant: BadgeVariant.soft),
                ZDSBadge(
                  label: 'Success',
                  color: context.colors.success,
                ),
                ZDSBadge(
                  label: 'Warning',
                  color: context.colors.warning,
                ),
                ZDSBadge(
                  label: 'Error',
                  color: context.colors.error,
                ),
                ZDSBadge.overlay(
                  count: 5,
                  child: Icon(
                    Icons.notifications,
                    size: 28,
                    color: context.colors.onSurface,
                  ),
                ),
                ZDSBadge.overlay(
                  count: 120,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Layout Helpers Section
            Text('Layout Helpers', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Section(
              title: 'Section with Title',
              subtitle: 'This is a section component for organizing content',
              child: Text(
                'Section content goes here. Sections help group related content with consistent styling.',
                style: context.typography.bodyMedium,
              ),
            ),
            const VerticalSpacing.m(),
            Section(
              title: 'Section with Actions',
              showDivider: true,
              actions: [
                ZDSButton.icon(
                  icon: Icons.edit,
                  onPressed: () => _showSnackBar(context, 'Edit pressed!'),
                  tooltip: 'Edit',
                ),
                ZDSButton.icon(
                  icon: Icons.delete,
                  onPressed: () => _showSnackBar(context, 'Delete pressed!'),
                  tooltip: 'Delete',
                ),
              ],
              child: Text(
                'This section has action buttons in the header and a divider at the bottom.',
                style: context.typography.bodyMedium,
              ),
            ),
            const VerticalSpacing.m(),
            Row(
              children: [
                PaddedContainer.small(
                  color: context.colors.primary?.withOpacity(0.1),
                  child: Text(
                    'Small Padding',
                    style: context.typography.bodySmall,
                  ),
                ),
                const HorizontalSpacing.m(),
                PaddedContainer.medium(
                  color: context.colors.secondary?.withOpacity(0.1),
                  child: Text(
                    'Medium Padding',
                    style: context.typography.bodySmall,
                  ),
                ),
                const HorizontalSpacing.m(),
                PaddedContainer.large(
                  color: context.colors.info?.withOpacity(0.1),
                  child: Text(
                    'Large Padding',
                    style: context.typography.bodySmall,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacing.xl),

            // Typography Section
            Text('Typography', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Text('Headline Large', style: context.typography.headlineLarge),
            Text('Title Large', style: context.typography.titleLarge),
            Text('Body Large', style: context.typography.bodyLarge),
            Text('Body Medium', style: context.typography.bodyMedium),
            Text('Label Small', style: context.typography.labelSmall),

            SizedBox(height: context.spacing.xl),

            // Colors Section
            Text('Colors', style: context.typography.titleLarge),
            SizedBox(height: context.spacing.m),
            Wrap(
              spacing: context.spacing.m,
              runSpacing: context.spacing.m,
              children: [
                _ColorSwatch(color: context.colors.primary, label: 'Primary'),
                _ColorSwatch(
                  color: context.colors.secondary,
                  label: 'Secondary',
                ),
                _ColorSwatch(color: context.colors.error, label: 'Error'),
                _ColorSwatch(color: context.colors.success, label: 'Success'),
                _ColorSwatch(color: context.colors.warning, label: 'Warning'),
                _ColorSwatch(color: context.colors.info, label: 'Info'),
                _ColorSwatch(color: context.colors.border, label: 'Border'),
                _ColorSwatch(color: context.colors.divider, label: 'Divider'),
                _ColorSwatch(color: context.colors.disabled, label: 'Disabled'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.label});

  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        SizedBox(height: context.spacing.xs),
        Text(label, style: context.typography.labelSmall),
      ],
    );
  }
}
