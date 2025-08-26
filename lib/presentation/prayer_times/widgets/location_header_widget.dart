import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationHeaderWidget extends StatelessWidget {
  final String city;
  final String country;
  final VoidCallback? onSettingsPressed;

  const LocationHeaderWidget({
    super.key,
    required this.city,
    required this.country,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Location Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'location_on',
              color: theme.colorScheme.primary,
              size: 5.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Location Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  country,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Settings Button
          IconButton(
            onPressed: onSettingsPressed ??
                () {
                  Navigator.pushNamed(context, '/settings');
                },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 6.w,
            ),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}
