import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SunTimesWidget extends StatelessWidget {
  final String sunriseTime;
  final String sunsetTime;

  const SunTimesWidget({
    super.key,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
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
          // Section Title
          Text(
            'Sun Times',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Sun Times Row
          Row(
            children: [
              // Sunrise
              Expanded(
                child: _buildSunTimeItem(
                  context,
                  'Sunrise',
                  'الشروق',
                  sunriseTime,
                  'wb_sunny',
                  theme.colorScheme.tertiary,
                ),
              ),

              SizedBox(width: 4.w),

              // Sunset
              Expanded(
                child: _buildSunTimeItem(
                  context,
                  'Sunset',
                  'الغروب',
                  sunsetTime,
                  'brightness_3',
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunTimeItem(
    BuildContext context,
    String englishName,
    String arabicName,
    String time,
    String iconName,
    Color iconColor,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon
          CustomIconWidget(
            iconName: iconName,
            color: iconColor,
            size: 6.w,
          ),

          SizedBox(height: 1.h),

          // Arabic Name
          Text(
            arabicName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 0.5.h),

          // English Name
          Text(
            englishName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          SizedBox(height: 1.h),

          // Time
          Text(
            time,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
