import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final CustomBottomBarVariant variant;
  final bool showLabels;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme);
      case CustomBottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, theme);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context, ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      elevation: elevation ?? 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      items: _getBottomNavigationBarItems(),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.6),
          elevation: 0,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: _getBottomNavigationBarItems(),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _getMinimalNavItems(context, theme),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'الرئيسية',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time_outlined),
        activeIcon: Icon(Icons.access_time),
        label: 'الصلاة',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.radio_button_unchecked),
        activeIcon: Icon(Icons.radio_button_checked),
        label: 'الذكر',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book_outlined),
        activeIcon: Icon(Icons.menu_book),
        label: 'الأحاديث',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book_outlined),
        activeIcon: Icon(Icons.book),
        label: 'القرآن',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore_outlined),
        activeIcon: Icon(Icons.explore),
        label: 'القبلة',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: 'الإعدادات',
      ),
    ];
  }

  List<Widget> _getMinimalNavItems(BuildContext context, ThemeData theme) {
    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'route': '/home-dashboard'
      },
      {
        'icon': Icons.access_time_outlined,
        'activeIcon': Icons.access_time,
        'route': '/prayer-times'
      },
      {
        'icon': Icons.radio_button_unchecked,
        'activeIcon': Icons.radio_button_checked,
        'route': '/dhikr-counter'
      },
      {
        'icon': Icons.menu_book_outlined,
        'activeIcon': Icons.menu_book,
        'route': '/hadith-collection'
      },
      {
        'icon': Icons.book_outlined,
        'activeIcon': Icons.book,
        'route': '/quran-reader'
      },
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'route': '/qibla-compass'
      },
      {
        'icon': Icons.settings_outlined,
        'activeIcon': Icons.settings,
        'route': '/settings'
      },
    ];

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = currentIndex == index;

      return GestureDetector(
        onTap: () => _handleNavigation(context, index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Icon(
            isSelected
                ? item['activeIcon'] as IconData
                : item['icon'] as IconData,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 24,
          ),
        ),
      );
    }).toList();
  }

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    onTap(index);

    final routes = [
      '/home-dashboard',
      '/prayer-times',
      '/dhikr-counter',
      '/hadith-collection',
      '/quran-reader',
      '/qibla-compass',
      '/settings',
    ];

    if (index < routes.length) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (route) => false,
      );
    }
  }
}
