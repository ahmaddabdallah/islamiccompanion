import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuranTextWidget extends StatelessWidget {
  final Map<String, dynamic> surahData;
  final double fontSize;
  final double lineSpacing;
  final List<Map<String, dynamic>> bookmarks;
  final Function(int surah, int verse) onVerseBookmark;
  final Function(String verseKey) onVerseTap;

  const QuranTextWidget({
    super.key,
    required this.surahData,
    required this.fontSize,
    required this.lineSpacing,
    required this.bookmarks,
    required this.onVerseBookmark,
    required this.onVerseTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verses = surahData['verses'] as List<dynamic>? ?? [];

    if (verses.isEmpty) {
      return Center(
        child: Text(
          'لا توجد آيات متاحة',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];
        final verseNumber = verse['number'] as int;
        final verseText = verse['text'] as String;
        final verseKey = '${surahData['number']}:$verseNumber';

        final isBookmarked = bookmarks.any((b) => b['key'] == verseKey);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Verse header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    // Verse number in Arabic style
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _convertToArabicNumerals(verseNumber.toString()),
                          style: GoogleFonts.inter(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Actions
                    IconButton(
                      onPressed: () => onVerseTap(verseKey),
                      icon: const Icon(Icons.info_outline, size: 20),
                      tooltip: 'التفسير',
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          onVerseBookmark(surahData['number'], verseNumber),
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: isBookmarked ? theme.colorScheme.primary : null,
                      ),
                      tooltip: isBookmarked ? 'إزالة العلامة' : 'إضافة علامة',
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _shareVerse(verseText, verseKey),
                      icon: const Icon(Icons.share, size: 20),
                      tooltip: 'مشاركة الآية',
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),
              ),

              // Verse text
              GestureDetector(
                onTap: () => onVerseTap(verseKey),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    verseText,
                    style: GoogleFonts.notoSansArabic(
                      fontSize: fontSize,
                      height: lineSpacing,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _convertToArabicNumerals(String number) {
    const englishToArabic = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };

    return number
        .split('')
        .map((digit) => englishToArabic[digit] ?? digit)
        .join('');
  }

  void _shareVerse(String verseText, String verseKey) {
    // Implementation for sharing verse
    // This would use the share package in a real implementation
  }
}
