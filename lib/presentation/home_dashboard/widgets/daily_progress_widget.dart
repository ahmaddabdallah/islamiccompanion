import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DailyProgressWidget extends StatelessWidget {
  final List<Map<String, dynamic>> progressData;

  const DailyProgressWidget({
    super.key,
    required this.progressData,
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
          Text(
            'Daily Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: progressData
                .map((progress) => _buildProgressItem(
                      context,
                      progress,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      BuildContext context, Map<String, dynamic> progress) {
    final theme = Theme.of(context);
    final double progressValue =
        (progress['completed'] as int) / (progress['total'] as int);

    return Expanded(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 15.w,
                height: 15.w,
                child: CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '${(progressValue * 100).toInt()}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            progress['titleArabic'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            progress['titleEnglish'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
