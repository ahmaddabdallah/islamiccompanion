import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/current_prayer_card_widget.dart';
import './widgets/daily_progress_widget.dart';
import './widgets/prayer_schedule_preview_widget.dart';
import './widgets/quick_actions_grid_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentBottomNavIndex = 0;

  // Mock data for current prayer
  final Map<String, dynamic> _currentPrayer = {
    "nameArabic": "صلاة الظهر",
    "nameEnglish": "Dhuhr Prayer",
    "time": "12:30 PM",
    "isActive": true,
  };

  // Mock data for daily progress
  final List<Map<String, dynamic>> _dailyProgress = [
    {
      "titleArabic": "أذكار الصباح",
      "titleEnglish": "Morning Azkar",
      "completed": 8,
      "total": 10,
    },
    {
      "titleArabic": "أذكار المساء",
      "titleEnglish": "Evening Dhikr",
      "completed": 3,
      "total": 8,
    },
    {
      "titleArabic": "حديث اليوم",
      "titleEnglish": "Daily Hadith",
      "completed": 1,
      "total": 1,
    },
  ];

  // Mock data for quick actions
  final List<Map<String, dynamic>> _quickActions = [
    {
      "titleArabic": "عداد التسبيح",
      "titleEnglish": "Tasbeeh Counter",
      "icon": "radio_button_checked",
      "route": "/dhikr-counter",
    },
    {
      "titleArabic": "حديث عشوائي",
      "titleEnglish": "Random Hadith",
      "icon": "menu_book",
      "route": "/hadith-collection",
    },
    {
      "titleArabic": "العلامات المرجعية",
      "titleEnglish": "Bookmarks",
      "icon": "bookmark",
      "route": "/settings",
    },
    {
      "titleArabic": "الإعدادات",
      "titleEnglish": "Settings",
      "icon": "settings",
      "route": "/settings",
    },
  ];

  // Mock data for prayer schedule
  final List<Map<String, dynamic>> _prayerSchedule = [
    {
      "nameArabic": "صلاة الفجر",
      "nameEnglish": "Fajr",
      "time": "4:45 AM",
      "isActive": false,
    },
    {
      "nameArabic": "صلاة الظهر",
      "nameEnglish": "Dhuhr",
      "time": "12:30 PM",
      "isActive": true,
    },
    {
      "nameArabic": "صلاة العصر",
      "nameEnglish": "Asr",
      "time": "3:45 PM",
      "isActive": false,
    },
    {
      "nameArabic": "صلاة المغرب",
      "nameEnglish": "Maghrib",
      "time": "6:20 PM",
      "isActive": false,
    },
    {
      "nameArabic": "صلاة العشاء",
      "nameEnglish": "Isha",
      "time": "7:45 PM",
      "isActive": false,
    },
  ];

  String _timeRemaining = "2h 15m";

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    // Simulate countdown timer
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          // Update countdown logic would go here
          // For demo purposes, keeping static
        });
        _startCountdownTimer();
      }
    });
  }

  Future<void> _onRefresh() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Update prayer times and daily content
        _timeRemaining = "2h 14m"; // Simulate updated time
      });
    }
  }

  void _onQuickActionTap(String route) {
    Navigator.pushNamed(context, route);
  }

  void _onPrayerCardTap() {
    Navigator.pushNamed(context, '/prayer-times');
  }

  void _onPrayerCardLongPress() {
    _showPrayerQuickActions();
  }

  void _showPrayerQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'access_time',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('View All Prayers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/prayer-times');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('Notification Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _onViewAllPrayers() {
    Navigator.pushNamed(context, '/prayer-times');
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'السلام عليكم',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Welcome to Islamic Companion',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.shadow
                                    .withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'notifications_outlined',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Current Prayer Card
                CurrentPrayerCardWidget(
                  currentPrayer: _currentPrayer,
                  timeRemaining: _timeRemaining,
                  onTap: _onPrayerCardTap,
                  onLongPress: _onPrayerCardLongPress,
                ),

                // Daily Progress
                DailyProgressWidget(
                  progressData: _dailyProgress,
                ),

                // Prayer Schedule Preview
                PrayerSchedulePreviewWidget(
                  prayerSchedule: _prayerSchedule,
                  onViewAll: _onViewAllPrayers,
                ),

                // Quick Actions Grid
                QuickActionsGridWidget(
                  quickActions: _quickActions,
                  onActionTap: _onQuickActionTap,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        variant: CustomBottomBarVariant.standard,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/dhikr-counter'),
        tooltip: 'Dhikr Counter',
        child: CustomIconWidget(
          iconName: 'radio_button_checked',
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
