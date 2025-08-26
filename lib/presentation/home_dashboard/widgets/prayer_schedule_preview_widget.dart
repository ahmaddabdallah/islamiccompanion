import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrayerSchedulePreviewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> prayerSchedule;
  final VoidCallback? onViewAll;

  const PrayerSchedulePreviewWidget({
    super.key,
    required this.prayerSchedule,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Prayers',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'View All',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            children: prayerSchedule
                .take(3)
                .map((prayer) => _buildPrayerItem(
                      context,
                      prayer,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(BuildContext context, Map<String, dynamic> prayer) {
    final theme = Theme.of(context);
    final bool isActive = prayer['isActive'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prayer['nameArabic'] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    prayer['nameEnglish'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            prayer['time'] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
