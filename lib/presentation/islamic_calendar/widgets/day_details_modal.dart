import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../../widgets/custom_icon_widget.dart';

class DayDetailsModal extends StatelessWidget {
  final DateTime gregorianDate;
  final Map<String, int> hijriDate;
  final String hijriMonthName;
  final List<Map<String, dynamic>> events;
  final Map<String, String> prayerTimes;
  final Function(Map<String, dynamic>) onEventTap;

  const DayDetailsModal({
    super.key,
    required this.gregorianDate,
    required this.hijriDate,
    required this.hijriMonthName,
    required this.events,
    required this.prayerTimes,
    required this.onEventTap,
  });

  List<String> _getArabicPrayerNames() {
    return ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
  }

  List<String> _getPrayerKeys() {
    return ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prayerNames = _getArabicPrayerNames();
    final prayerKeys = _getPrayerKeys();

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'calendar_month',
                          color: theme.colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE، d MMMM yyyy')
                                  .format(gregorianDate),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${hijriDate['day']} $hijriMonthName ${hijriDate['year']} هـ',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary
                                    .withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prayer Times Section
                  if (prayerTimes.isNotEmpty) ...[
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'مواقيت الصلاة',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < prayerKeys.length; i++)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 3.w,
                              ),
                              decoration: BoxDecoration(
                                border: i < prayerKeys.length - 1
                                    ? Border(
                                        bottom: BorderSide(
                                          color: theme.colorScheme.outline
                                              .withValues(alpha: 0.1),
                                        ),
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'mosque',
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      prayerNames[i],
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    prayerTimes[prayerKeys[i]] ?? '--:--',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],

                  // Islamic Events Section
                  if (events.isNotEmpty) ...[
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'celebration',
                          color: theme.colorScheme.tertiary,
                          size: 24,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'الأحداث الإسلامية',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    for (final event in events)
                      Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getEventCategoryColor(
                                    theme, event['category'] ?? '')
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onEventTap(event),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                      color: _getEventCategoryColor(
                                          theme, event['category'] ?? ''),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getEventCategoryIcon(
                                          event['category'] ?? ''),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event['title_arabic'] ?? 'حدث إسلامي',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (event['title_english'] != null)
                                          Text(
                                            event['title_english'],
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  CustomIconWidget(
                                    iconName: 'chevron_right',
                                    color: theme.colorScheme.outline,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],

                  // Quick Actions
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/prayer-times');
                          },
                          icon: CustomIconWidget(
                            iconName: 'access_time',
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: const Text('مواقيت الصلاة'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/dhikr-counter');
                          },
                          icon: CustomIconWidget(
                            iconName: 'radio_button_checked',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          label: const Text('سبحة'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEventCategoryColor(ThemeData theme, String category) {
    switch (category.toLowerCase()) {
      case 'religious':
        return theme.colorScheme.primary;
      case 'celebration':
        return theme.colorScheme.tertiary;
      case 'ramadan':
        return const Color(0xFF6A4C93);
      case 'eid':
        return const Color(0xFFFF6B6B);
      default:
        return theme.colorScheme.secondary;
    }
  }

  IconData _getEventCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'religious':
        return Icons.mosque;
      case 'celebration':
        return Icons.celebration;
      case 'ramadan':
        return Icons.nightlight;
      case 'eid':
        return Icons.festival;
      default:
        return Icons.event;
    }
  }
}
