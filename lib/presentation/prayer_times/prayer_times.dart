import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/location_header_widget.dart';
import './widgets/prayer_card_widget.dart';
import './widgets/sun_times_widget.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({super.key});

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  final ScrollController _scrollController = ScrollController();
  String _currentTimeRemaining = '';
  int _currentPrayerIndex = 1; // Default to Dhuhr as current

  // Mock prayer times data for Cairo, Egypt
  final List<Map<String, dynamic>> _prayerTimes = [
    {
      "id": 1,
      "arabicName": "الفجر",
      "englishName": "Fajr",
      "time": "4:45 AM",
      "datetime": DateTime.now().copyWith(hour: 4, minute: 45, second: 0),
      "hasNotification": true,
    },
    {
      "id": 2,
      "arabicName": "الظهر",
      "englishName": "Dhuhr",
      "time": "12:15 PM",
      "datetime": DateTime.now().copyWith(hour: 12, minute: 15, second: 0),
      "hasNotification": true,
    },
    {
      "id": 3,
      "arabicName": "العصر",
      "englishName": "Asr",
      "time": "3:30 PM",
      "datetime": DateTime.now().copyWith(hour: 15, minute: 30, second: 0),
      "hasNotification": false,
    },
    {
      "id": 4,
      "arabicName": "المغرب",
      "englishName": "Maghrib",
      "time": "6:45 PM",
      "datetime": DateTime.now().copyWith(hour: 18, minute: 45, second: 0),
      "hasNotification": true,
    },
    {
      "id": 5,
      "arabicName": "العشاء",
      "englishName": "Isha",
      "time": "8:15 PM",
      "datetime": DateTime.now().copyWith(hour: 20, minute: 15, second: 0),
      "hasNotification": true,
    },
  ];

  final Map<String, String> _sunTimes = {
    "sunrise": "6:20 AM",
    "sunset": "6:30 PM",
  };

  @override
  void initState() {
    super.initState();
    _updateCurrentPrayer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateCurrentPrayer() {
    final now = DateTime.now();

    for (int i = 0; i < _prayerTimes.length; i++) {
      final prayerTime = _prayerTimes[i]['datetime'] as DateTime;
      final nextPrayerTime = i < _prayerTimes.length - 1
          ? _prayerTimes[i + 1]['datetime'] as DateTime
          : _prayerTimes[0]['datetime'] as DateTime; // Next day Fajr

      if (now.isBefore(prayerTime)) {
        setState(() {
          _currentPrayerIndex = i;
        });
        break;
      } else if (now.isAfter(prayerTime) && now.isBefore(nextPrayerTime)) {
        setState(() {
          _currentPrayerIndex = i < _prayerTimes.length - 1 ? i + 1 : 0;
        });
        break;
      }
    }
  }

  DateTime _getNextPrayerTime() {
    if (_currentPrayerIndex < _prayerTimes.length) {
      return _prayerTimes[_currentPrayerIndex]['datetime'] as DateTime;
    }
    // If it's after Isha, next prayer is tomorrow's Fajr
    return (_prayerTimes[0]['datetime'] as DateTime)
        .add(const Duration(days: 1));
  }

  String _getNextPrayerName() {
    if (_currentPrayerIndex < _prayerTimes.length) {
      return _prayerTimes[_currentPrayerIndex]['englishName'] as String;
    }
    return _prayerTimes[0]['englishName'] as String;
  }

  bool _isPastPrayer(int index) {
    final now = DateTime.now();
    final prayerTime = _prayerTimes[index]['datetime'] as DateTime;
    return now.isAfter(prayerTime) && index != _currentPrayerIndex;
  }

  Future<void> _refreshPrayerTimes() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Update current prayer
    _updateCurrentPrayer();

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prayer times updated'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onTimeUpdate(String timeRemaining) {
    if (mounted) {
      setState(() {
        _currentTimeRemaining = timeRemaining;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Prayer Times',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: theme.colorScheme.onSurface,
            size: 5.w,
          ),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home-dashboard',
            (route) => false,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 6.w,
            ),
            onPressed: _refreshPrayerTimes,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPrayerTimes,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Location Header
            SliverToBoxAdapter(
              child: LocationHeaderWidget(
                city: 'Cairo',
                country: 'Egypt',
                onSettingsPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),

            // Countdown Timer
            SliverToBoxAdapter(
              child: CountdownTimerWidget(
                nextPrayerTime: _getNextPrayerTime(),
                nextPrayerName: _getNextPrayerName(),
                onTimeUpdate: _onTimeUpdate,
              ),
            ),

            // Prayer Times List
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Text(
                  'Today\'s Prayer Times',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final prayer = _prayerTimes[index];
                  final isCurrentPrayer = index == _currentPrayerIndex;
                  final isPastPrayer = _isPastPrayer(index);

                  return Dismissible(
                    key: Key('prayer_${prayer['id']}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 6.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'notifications',
                            color: theme.colorScheme.onPrimary,
                            size: 6.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Set Reminder',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // Show reminder set confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Reminder set for ${prayer['englishName']}'),
                          backgroundColor: theme.colorScheme.primary,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return false; // Don't actually dismiss
                    },
                    child: PrayerCardWidget(
                      prayer: prayer,
                      isCurrentPrayer: isCurrentPrayer,
                      isPastPrayer: isPastPrayer,
                      timeRemaining:
                          isCurrentPrayer ? _currentTimeRemaining : null,
                    ),
                  );
                },
                childCount: _prayerTimes.length,
              ),
            ),

            // Sun Times
            SliverToBoxAdapter(
              child: SunTimesWidget(
                sunriseTime: _sunTimes['sunrise']!,
                sunsetTime: _sunTimes['sunset']!,
              ),
            ),

            // Bottom Spacing
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 'home', 'Home', '/home-dashboard'),
                _buildNavItem(context, 'access_time', 'Prayer', '/prayer-times',
                    isActive: true),
                _buildNavItem(
                    context, 'radio_button_checked', 'Dhikr', '/dhikr-counter'),
                _buildNavItem(
                    context, 'menu_book', 'Hadith', '/hadith-collection'),
                _buildNavItem(context, 'settings', 'Settings', '/settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String iconName, String label, String route,
      {bool isActive = false}) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 6.w,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
