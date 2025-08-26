import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  prayer,
  reading,
  settings,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: _buildTitle(context),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? _getBackgroundColor(theme),
      foregroundColor: foregroundColor ?? _getForegroundColor(theme),
      elevation: elevation ?? _getElevation(),
      surfaceTintColor: Colors.transparent,
      leading: leading ?? _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomAppBarVariant.prayer:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme),
              ),
            ),
          ],
        );

      case CustomAppBarVariant.reading:
        return Text(
          title,
          style: GoogleFonts.notoSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _getForegroundColor(theme),
          ),
        );

      case CustomAppBarVariant.settings:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.settings,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getForegroundColor(theme),
              ),
            ),
          ],
        );

      case CustomAppBarVariant.standard:
      default:
        return Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _getForegroundColor(theme),
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (!showBackButton) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20,
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> actionWidgets = [];

    // Add variant-specific actions
    switch (variant) {
      case CustomAppBarVariant.prayer:
        actionWidgets.add(
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Prayer Notifications',
          ),
        );
        break;

      case CustomAppBarVariant.reading:
        actionWidgets.addAll([
          IconButton(
            icon: Icon(Icons.bookmark_outline),
            onPressed: () {
              // Handle bookmark action
            },
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              // Handle share action
            },
            tooltip: 'Share',
          ),
        ]);
        break;

      case CustomAppBarVariant.settings:
        actionWidgets.add(
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Handle help action
            },
            tooltip: 'Help',
          ),
        );
        break;

      case CustomAppBarVariant.standard:
      default:
        break;
    }

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (variant) {
      case CustomAppBarVariant.reading:
        return theme.colorScheme.surface;
      default:
        return theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    }
  }

  Color _getForegroundColor(ThemeData theme) {
    return theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;
  }

  double _getElevation() {
    switch (variant) {
      case CustomAppBarVariant.reading:
        return 0;
      default:
        return 0;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
