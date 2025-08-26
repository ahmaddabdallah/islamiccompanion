import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  pills,
  underline,
  segmented,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final TabController controller;
  final CustomTabBarVariant variant;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double? indicatorWeight;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.controller,
    this.variant = CustomTabBarVariant.standard,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, theme);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context, theme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, theme);
      case CustomTabBarVariant.standard:
      default:
        return _buildStandardTabBar(context, theme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        labelColor: labelColor ?? theme.colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorWeight: indicatorWeight ?? 2.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context, ThemeData theme) {
    return Container(
      height: 48,
      padding: padding ?? const EdgeInsets.all(16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = controller.index == index;
          return GestureDetector(
            onTap: () => controller.animateTo(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnderlineTabBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        labelColor: labelColor ?? theme.colorScheme.onSurface,
        unselectedLabelColor: unselectedLabelColor ??
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorWeight: indicatorWeight ?? 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs
            .map((tab) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(tab),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = controller.index == index;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => controller.animateTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? const Radius.circular(7) : Radius.zero,
                    right: isLast ? const Radius.circular(7) : Radius.zero,
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Size get preferredSize {
    switch (variant) {
      case CustomTabBarVariant.pills:
        return const Size.fromHeight(48);
      case CustomTabBarVariant.segmented:
        return const Size.fromHeight(64);
      default:
        return const Size.fromHeight(48);
    }
  }
}
