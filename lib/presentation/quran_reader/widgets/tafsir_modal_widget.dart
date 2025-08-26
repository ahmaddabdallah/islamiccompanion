import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TafsirModalWidget extends StatelessWidget {
  final String verseKey;
  final VoidCallback onClose;

  const TafsirModalWidget({
    super.key,
    required this.verseKey,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = verseKey.split(':');
    final surahNumber = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 1 : 1;
    final verseNumber = parts.length > 1 ? int.tryParse(parts[1]) ?? 1 : 1;

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفسير الآية',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        '${_getSurahName(surahNumber)} • آية $verseNumber',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tafsir content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Verse text
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'نص الآية',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getVerseText(surahNumber, verseNumber),
                            style: GoogleFonts.notoSansArabic(
                              fontSize: 18,
                              height: 1.8,
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tafsir sections
                  _buildTafsirSection(
                    theme,
                    'تفسير ابن كثير',
                    _getIbnKathirTafsir(surahNumber, verseNumber),
                    Icons.book,
                  ),

                  const SizedBox(height: 12),

                  _buildTafsirSection(
                    theme,
                    'التفسير الميسر',
                    _getSimpleTafsir(surahNumber, verseNumber),
                    Icons.lightbulb_outline,
                  ),

                  const SizedBox(height: 12),

                  _buildTafsirSection(
                    theme,
                    'أسباب النزول',
                    _getRevelationReason(surahNumber, verseNumber),
                    Icons.history,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTafsirSection(
    ThemeData theme,
    String title,
    String content,
    IconData icon,
  ) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: GoogleFonts.notoSansArabic(
                fontSize: 16,
                height: 1.6,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  String _getSurahName(int surahNumber) {
    final surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      4: 'النساء',
      5: 'المائدة',
    };
    return surahNames[surahNumber] ?? 'سورة $surahNumber';
  }

  String _getVerseText(int surahNumber, int verseNumber) {
    // Mock verse text - in a real app, this would come from the Quran API
    if (surahNumber == 1 && verseNumber == 1) {
      return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
    } else if (surahNumber == 1 && verseNumber == 2) {
      return 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ';
    }
    return 'نص الآية غير متوفر';
  }

  String _getIbnKathirTafsir(int surahNumber, int verseNumber) {
    // Mock tafsir - in a real app, this would come from a tafsir database
    if (surahNumber == 1 && verseNumber == 1) {
      return 'يقول الله تعالى: اقرأ يا محمد باسم ربك الذي خلق كل شيء... هذا تفسير مبسط لغرض التوضيح فقط. في التطبيق الحقيقي، يجب أن يتم جلب التفسير من مصادر موثوقة.';
    } else if (surahNumber == 1 && verseNumber == 2) {
      return 'الحمد لله: أي الثناء على الله بصفاته التي كلها أوصاف كمال، وبنعمه الظاهرة والباطنة... هذا أيضاً تفسير مبسط للتوضيح.';
    }
    return 'التفسير غير متوفر حالياً لهذه الآية.';
  }

  String _getSimpleTafsir(int surahNumber, int verseNumber) {
    // Mock simple tafsir
    if (surahNumber == 1 && verseNumber == 1) {
      return 'أبدأ قراءتي باسم الله الرحمن الرحيم، فهو الذي يستحق أن يُبدأ باسمه كل عمل.';
    } else if (surahNumber == 1 && verseNumber == 2) {
      return 'الحمد والثناء لله وحده، فهو رب جميع المخلوقات ومالكها ومدبر أمورها.';
    }
    return 'التفسير الميسر غير متوفر حالياً لهذه الآية.';
  }

  String _getRevelationReason(int surahNumber, int verseNumber) {
    // Mock revelation reasons
    if (surahNumber == 1) {
      return 'سورة الفاتحة من السور المكية، وهي أول سورة نزلت كاملة، وتسمى أم الكتاب وأم القرآن.';
    }
    return 'أسباب النزول غير متوفرة حالياً لهذه الآية.';
  }
}
