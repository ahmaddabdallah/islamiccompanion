import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HadithPreviewWidget extends StatelessWidget {
  final Map<String, dynamic> hadith;
  final VoidCallback? onTap;

  const HadithPreviewWidget({
    super.key,
    required this.hadith,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewText(context, theme),
            SizedBox(height: 1.h),
            _buildSourceInfo(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewText(BuildContext context, ThemeData theme) {
    final englishText = hadith['englishTranslation'] as String? ?? '';
    final previewText = englishText.length > 120
        ? '${englishText.substring(0, 120)}...'
        : englishText;

    return Text(
      previewText,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface,
        height: 1.5,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSourceInfo(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'menu_book',
          color: theme.colorScheme.primary,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            hadith['source'] as String? ?? '',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 12,
        ),
      ],
    );
  }
}