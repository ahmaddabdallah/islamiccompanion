import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/app_info_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Prayer Settings State
  bool _fajrNotification = true;
  bool _dhuhrNotification = true;
  bool _asrNotification = true;
  bool _maghribNotification = true;
  bool _ishaNotification = true;
  String _alertTone = 'Default Adhan';
  String _notificationTiming = '10 minutes before';

  // Display Preferences State
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';
  String _arabicFontSize = 'Medium';

  // Audio Settings State
  String _selectedReciter = 'Abdul Rahman Al-Sudais';
  bool _downloadForOffline = false;
  String _audioQuality = 'High';

  // Data & Privacy State
  bool _cloudSync = false;
  bool _hasAccount = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      // Load other settings as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Settings',
        variant: CustomAppBarVariant.settings,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Prayer Settings Section
            SettingsSectionWidget(
              title: 'Prayer Settings',
              children: [
                SettingsItemWidget(
                  title: 'Fajr Notifications',
                  subtitle: 'Get notified for Fajr prayer',
                  iconName: 'wb_sunny',
                  type: SettingsItemType.toggle,
                  value: _fajrNotification,
                  onToggle: (value) =>
                      setState(() => _fajrNotification = value),
                ),
                SettingsItemWidget(
                  title: 'Dhuhr Notifications',
                  subtitle: 'Get notified for Dhuhr prayer',
                  iconName: 'wb_sunny',
                  type: SettingsItemType.toggle,
                  value: _dhuhrNotification,
                  onToggle: (value) =>
                      setState(() => _dhuhrNotification = value),
                ),
                SettingsItemWidget(
                  title: 'Asr Notifications',
                  subtitle: 'Get notified for Asr prayer',
                  iconName: 'wb_sunny',
                  type: SettingsItemType.toggle,
                  value: _asrNotification,
                  onToggle: (value) => setState(() => _asrNotification = value),
                ),
                SettingsItemWidget(
                  title: 'Maghrib Notifications',
                  subtitle: 'Get notified for Maghrib prayer',
                  iconName: 'wb_twilight',
                  type: SettingsItemType.toggle,
                  value: _maghribNotification,
                  onToggle: (value) =>
                      setState(() => _maghribNotification = value),
                ),
                SettingsItemWidget(
                  title: 'Isha Notifications',
                  subtitle: 'Get notified for Isha prayer',
                  iconName: 'nights_stay',
                  type: SettingsItemType.toggle,
                  value: _ishaNotification,
                  onToggle: (value) =>
                      setState(() => _ishaNotification = value),
                ),
                SettingsItemWidget(
                  title: 'Alert Tone',
                  subtitle: 'Choose your preferred adhan',
                  iconName: 'volume_up',
                  type: SettingsItemType.selection,
                  selectedValue: _alertTone,
                  onTap: () => _showAlertToneSelection(),
                ),
                SettingsItemWidget(
                  title: 'Notification Timing',
                  subtitle: 'When to receive prayer reminders',
                  iconName: 'schedule',
                  type: SettingsItemType.selection,
                  selectedValue: _notificationTiming,
                  onTap: () => _showNotificationTimingSelection(),
                ),
              ],
            ),

            // Display Preferences Section
            SettingsSectionWidget(
              title: 'Display Preferences',
              children: [
                SettingsItemWidget(
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark theme',
                  iconName: _isDarkMode ? 'dark_mode' : 'light_mode',
                  type: SettingsItemType.toggle,
                  value: _isDarkMode,
                  onToggle: (value) => _toggleTheme(value),
                ),
                SettingsItemWidget(
                  title: 'Language',
                  subtitle: 'App display language',
                  iconName: 'language',
                  type: SettingsItemType.selection,
                  selectedValue: _selectedLanguage,
                  onTap: () => _showLanguageSelection(),
                ),
                SettingsItemWidget(
                  title: 'Arabic Font Size',
                  subtitle: 'Adjust Arabic text readability',
                  iconName: 'text_fields',
                  type: SettingsItemType.selection,
                  selectedValue: _arabicFontSize,
                  onTap: () => _showFontSizeSelection(),
                ),
              ],
            ),

            // Audio Settings Section
            SettingsSectionWidget(
              title: 'Audio Settings',
              children: [
                SettingsItemWidget(
                  title: 'Quran Reciter',
                  subtitle: 'Choose your preferred reciter',
                  iconName: 'record_voice_over',
                  type: SettingsItemType.selection,
                  selectedValue: _selectedReciter,
                  onTap: () => _showReciterSelection(),
                ),
                SettingsItemWidget(
                  title: 'Download for Offline',
                  subtitle: 'Save audio for offline listening',
                  iconName: 'download',
                  type: SettingsItemType.toggle,
                  value: _downloadForOffline,
                  onToggle: (value) =>
                      setState(() => _downloadForOffline = value),
                ),
                SettingsItemWidget(
                  title: 'Audio Quality',
                  subtitle: 'Choose audio streaming quality',
                  iconName: 'high_quality',
                  type: SettingsItemType.selection,
                  selectedValue: _audioQuality,
                  onTap: () => _showAudioQualitySelection(),
                ),
              ],
            ),

            // Data & Privacy Section
            SettingsSectionWidget(
              title: 'Data & Privacy',
              children: [
                SettingsItemWidget(
                  title: _hasAccount ? 'Account Settings' : 'Create Account',
                  subtitle: _hasAccount
                      ? 'Manage your account preferences'
                      : 'Sign up for cloud sync and backup',
                  iconName: 'account_circle',
                  type: SettingsItemType.disclosure,
                  onTap: () => _handleAccountAction(),
                ),
                SettingsItemWidget(
                  title: 'Cloud Sync',
                  subtitle: 'Sync bookmarks and progress across devices',
                  iconName: 'cloud_sync',
                  type: SettingsItemType.toggle,
                  value: _cloudSync,
                  onToggle: _hasAccount
                      ? (value) => setState(() => _cloudSync = value)
                      : null,
                ),
                SettingsItemWidget(
                  title: 'Export Data',
                  subtitle: 'Download your app data',
                  iconName: 'file_download',
                  type: SettingsItemType.disclosure,
                  onTap: () => _exportUserData(),
                ),
              ],
            ),

            // App Information
            const AppInfoWidget(),

            SizedBox(height: 10.h),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 4,
        onTap: _handleBottomNavigation,
      ),
    );
  }

  static void _handleBottomNavigation(int index) {
    // Navigation handled by CustomBottomBar
  }

  void _toggleTheme(bool isDark) {
    setState(() => _isDarkMode = isDark);
    // Here you would typically update the app theme
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isDark ? 'Dark mode enabled' : 'Light mode enabled'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAlertToneSelection() {
    final alertTones = [
      'Default Adhan',
      'Makkah Adhan',
      'Madinah Adhan',
      'Al-Aqsa Adhan',
      'Simple Bell',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Alert Tone'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: alertTones
              .map((tone) => RadioListTile<String>(
                    title: Text(tone),
                    value: tone,
                    groupValue: _alertTone,
                    onChanged: (value) {
                      setState(() => _alertTone = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showNotificationTimingSelection() {
    final timings = [
      '5 minutes before',
      '10 minutes before',
      '15 minutes before',
      '30 minutes before',
      'At prayer time',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Timing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: timings
              .map((timing) => RadioListTile<String>(
                    title: Text(timing),
                    value: timing,
                    groupValue: _notificationTiming,
                    onChanged: (value) {
                      setState(() => _notificationTiming = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    final languages = ['English', 'العربية'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages
              .map((language) => RadioListTile<String>(
                    title: Text(language),
                    value: language,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      if (value != _selectedLanguage) {
                        _showLanguageChangeConfirmation(value!);
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLanguageChangeConfirmation(String newLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language Change'),
        content: const Text(
          'Changing the language will restart the app to apply the changes. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', newLanguage);

              setState(() {
                _selectedLanguage = newLanguage;
              });

              Navigator.of(context).pop();
              Navigator.of(context).pop();

              final newLocale = newLanguage == 'English' ? const Locale('en') : const Locale('ar');
              MyApp.setLocale(context, newLocale);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Language changed to $newLanguage'),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeSelection() {
    final fontSizes = ['Small', 'Medium', 'Large', 'Extra Large'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arabic Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: fontSizes
              .map((size) => RadioListTile<String>(
                    title: Text(size),
                    subtitle: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: TextStyle(
                        fontSize: size == 'Small'
                            ? 12
                            : size == 'Medium'
                                ? 16
                                : size == 'Large'
                                    ? 20
                                    : 24,
                      ),
                    ),
                    value: size,
                    groupValue: _arabicFontSize,
                    onChanged: (value) {
                      setState(() => _arabicFontSize = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showReciterSelection() {
    final reciters = [
      'Abdul Rahman Al-Sudais',
      'Mishary Rashid Alafasy',
      'Saad Al-Ghamdi',
      'Maher Al-Muaiqly',
      'Ahmed Al-Ajmy',
      'Yasser Al-Dosari',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Reciter'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: reciters.length,
            itemBuilder: (context, index) {
              final reciter = reciters[index];
              return RadioListTile<String>(
                title: Text(reciter),
                value: reciter,
                groupValue: _selectedReciter,
                onChanged: (value) {
                  setState(() => _selectedReciter = value!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAudioQualitySelection() {
    final qualities = ['Low (64 kbps)', 'Medium (128 kbps)', 'High (320 kbps)'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Audio Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: qualities
              .map((quality) => RadioListTile<String>(
                    title: Text(quality.split(' ')[0]),
                    subtitle: Text(quality),
                    value: quality.split(' ')[0],
                    groupValue: _audioQuality,
                    onChanged: (value) {
                      setState(() => _audioQuality = value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _handleAccountAction() {
    if (_hasAccount) {
      // Show account settings
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Account Settings'),
          content: const Text(
              'Account management features will be available in future updates.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Show account creation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Create Account'),
          content: const Text(
            'Account creation and cloud sync features will be available in future updates. Your data is currently stored locally on your device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _exportUserData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Data export functionality will be available in future updates. Currently, all your data is stored locally on your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
