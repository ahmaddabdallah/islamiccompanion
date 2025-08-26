import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrayerCardWidget extends StatelessWidget {
  final Map<String, dynamic> prayer;
  final bool isCurrentPrayer;
  final bool isPastPrayer;
  final String? timeRemaining;

  const PrayerCardWidget({
    super.key,
    required this.prayer,
    this.isCurrentPrayer = false,
    this.isPastPrayer = false,
    this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getCardColor(theme),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentPrayer
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Prayer Icon
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isCurrentPrayer
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'mosque',
                color: isCurrentPrayer
                    ? theme.colorScheme.primary
                    : isPastPrayer
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                        : theme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),

            SizedBox(width: 4.w),

            // Prayer Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic Name
                  Text(
                    prayer['arabicName'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPastPrayer
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                          : theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  // English Name
                  Text(
                    prayer['englishName'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isPastPrayer
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Time and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Prayer Time
                Text(
                  prayer['time'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isCurrentPrayer
                        ? theme.colorScheme.primary
                        : isPastPrayer
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                            : theme.colorScheme.onSurface,
                  ),
                ),

                if (isCurrentPrayer && timeRemaining != null) ...[
                  SizedBox(height: 0.5.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      timeRemaining!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                if (prayer['hasNotification'] == true) ...[
                  SizedBox(height: 0.5.h),
                  CustomIconWidget(
                    iconName: 'notifications',
                    color: theme.colorScheme.primary,
                    size: 4.w,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor(ThemeData theme) {
    if (isCurrentPrayer) {
      return theme.colorScheme.primary.withValues(alpha: 0.05);
    } else if (isPastPrayer) {
      return theme.colorScheme.surface.withValues(alpha: 0.5);
    } else {
      return theme.colorScheme.surface;
    }
  }
}
