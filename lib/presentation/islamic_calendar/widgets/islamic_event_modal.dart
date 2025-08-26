import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/custom_icon_widget.dart';

class IslamicEventModal extends StatelessWidget {
  final Map<String, dynamic> event;

  const IslamicEventModal({
    super.key,
    required this.event,
  });

  IconData _getCategoryIcon(String category) {
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

  Color _getCategoryColor(BuildContext context, String category) {
    final theme = Theme.of(context);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = _getCategoryColor(context, event['category'] ?? '');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxHeight: 70.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(event['category'] ?? ''),
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title_arabic'] ?? 'حدث إسلامي',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          event['title_english'] ?? 'Islamic Event',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (event['description'] != null) ...[
                      Text(
                        'الوصف',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        event['description'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Significance
                    if (event['significance'] != null) ...[
                      Text(
                        'الأهمية',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        event['significance'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],

                    // Category chip
                    Chip(
                      backgroundColor: categoryColor.withValues(alpha: 0.1),
                      label: Text(
                        _getCategoryDisplayName(event['category'] ?? ''),
                        style: TextStyle(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      side: BorderSide(color: categoryColor),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Add reminder functionality
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم إضافة تذكير لهذا الحدث'),
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'notifications',
                        color: categoryColor,
                        size: 20,
                      ),
                      label: const Text('إضافة تذكير'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: categoryColor,
                        side: BorderSide(color: categoryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Share functionality
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم نسخ تفاصيل الحدث'),
                          ),
                        );
                      },
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                      ),
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

  String _getCategoryDisplayName(String category) {
    switch (category.toLowerCase()) {
      case 'religious':
        return 'ديني';
      case 'celebration':
        return 'احتفال';
      case 'ramadan':
        return 'رمضان';
      case 'eid':
        return 'عيد';
      default:
        return 'حدث';
    }
  }
}
