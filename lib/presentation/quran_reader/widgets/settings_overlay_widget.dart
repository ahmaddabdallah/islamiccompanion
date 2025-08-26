import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsOverlayWidget extends StatelessWidget {
  final double fontSize;
  final double lineSpacing;
  final Function(double) onFontSizeChanged;
  final Function(double) onLineSpacingChanged;
  final VoidCallback onClose;

  const SettingsOverlayWidget({
    super.key,
    required this.fontSize,
    required this.lineSpacing,
    required this.onFontSizeChanged,
    required this.onLineSpacingChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.95),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'إغلاق',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إعدادات القراءة',
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            // Settings content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Font size section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.format_size,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'حجم الخط',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Font size slider
                          Row(
                            children: [
                              Text('صغير', style: theme.textTheme.bodySmall),
                              Expanded(
                                child: Slider(
                                  value: fontSize,
                                  min: 12.0,
                                  max: 32.0,
                                  divisions: 20,
                                  label: fontSize.round().toString(),
                                  onChanged: onFontSizeChanged,
                                ),
                              ),
                              Text('كبير', style: theme.textTheme.bodySmall),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Font size preview
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                              style: GoogleFonts.notoSansArabic(
                                fontSize: fontSize,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Line spacing section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.format_line_spacing,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'تباعد الأسطر',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Line spacing slider
                          Row(
                            children: [
                              Text('ضيق', style: theme.textTheme.bodySmall),
                              Expanded(
                                child: Slider(
                                  value: lineSpacing,
                                  min: 1.2,
                                  max: 2.5,
                                  divisions: 13,
                                  label: lineSpacing.toStringAsFixed(1),
                                  onChanged: onLineSpacingChanged,
                                ),
                              ),
                              Text('واسع', style: theme.textTheme.bodySmall),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Line spacing preview
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\nالرَّحْمَٰنِ الرَّحِيمِ\nمَالِكِ يَوْمِ الدِّينِ',
                              style: GoogleFonts.notoSansArabic(
                                fontSize: fontSize,
                                height: lineSpacing,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Additional settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.palette,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'المظهر',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Theme options (disabled for now)
                          ListTile(
                            leading: const Icon(Icons.wb_sunny_outlined),
                            title: const Text('المظهر الفاتح'),
                            trailing: Radio<String>(
                              value: 'light',
                              groupValue: 'light',
                              onChanged: null, // Disabled for now
                            ),
                          ),

                          ListTile(
                            leading: const Icon(Icons.dark_mode_outlined),
                            title: const Text('المظهر المظلم'),
                            trailing: Radio<String>(
                              value: 'dark',
                              groupValue: 'light',
                              onChanged: null, // Disabled for now
                            ),
                          ),
                        ],
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
}
