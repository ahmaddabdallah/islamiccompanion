import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CalendarCellWidget extends StatelessWidget {
  final DateTime day;
  final Map<String, int> hijriDate;
  final bool hasEvents;
  final bool hasPrayerTimes;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const CalendarCellWidget({
    super.key,
    required this.day,
    required this.hijriDate,
    this.hasEvents = false,
    this.hasPrayerTimes = false,
    this.isSelected = false,
    this.isToday = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color backgroundColor = Colors.transparent;
    Color textColor = theme.colorScheme.onSurface;
    Color borderColor = Colors.transparent;

    if (isSelected) {
      backgroundColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else if (isToday) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.1);
      borderColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(0.5.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: isToday ? 2 : 0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(1.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gregorian day
                  Text(
                    '${day.day}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),

                  // Hijri day
                  Text(
                    '${hijriDate['day']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Event indicators
            if (hasEvents || hasPrayerTimes)
              Positioned(
                top: 1.w,
                right: 1.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasEvents)
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    if (hasEvents && hasPrayerTimes) SizedBox(width: 0.5.w),
                    if (hasPrayerTimes)
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
