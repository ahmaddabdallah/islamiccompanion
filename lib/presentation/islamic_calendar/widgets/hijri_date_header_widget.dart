import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class HijriDateHeaderWidget extends StatelessWidget {
  final Map<String, int> hijriDate;
  final String hijriMonthName;

  const HijriDateHeaderWidget({
    super.key,
    required this.hijriDate,
    required this.hijriMonthName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gregorianDate = DateTime.now();
    final arabicDateFormatter = DateFormat('EEEE، d MMMM yyyy', 'ar');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hijri Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${hijriDate['day']}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              ),
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hijriMonthName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    '${hijriDate['year']} هـ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Divider
          Container(
            height: 1,
            width: 30.w,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
          ),

          SizedBox(height: 1.h),

          // Gregorian Date
          Text(
            DateFormat('EEEE، d MMMM yyyy').format(gregorianDate),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
