import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SettingsItemType {
  toggle,
  disclosure,
  selection,
  action,
}

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final SettingsItemType type;
  final bool? value;
  final String? selectedValue;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;
  final bool showDivider;
  final Color? iconColor;

  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.iconName,
    required this.type,
    this.value,
    this.selectedValue,
    this.onTap,
    this.onToggle,
    this.showDivider = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: type == SettingsItemType.toggle ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            if (iconName != null) ...[
              CustomIconWidget(
                iconName: iconName!,
                color: iconColor ?? theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _buildTrailingWidget(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context, ThemeData theme) {
    switch (type) {
      case SettingsItemType.toggle:
        return Switch(
          value: value ?? false,
          onChanged: onToggle,
          activeColor: theme.colorScheme.primary,
        );

      case SettingsItemType.disclosure:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          size: 20,
        );

      case SettingsItemType.selection:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedValue != null) ...[
              Text(
                selectedValue!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(width: 2.w),
            ],
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        );

      case SettingsItemType.action:
        return const SizedBox.shrink();
    }
  }
}
