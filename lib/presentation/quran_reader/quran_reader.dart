import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/audio_controls_widget.dart';
import './widgets/bookmark_list_widget.dart';
import './widgets/quran_text_widget.dart';
import './widgets/search_overlay_widget.dart';
import './widgets/settings_overlay_widget.dart';
import './widgets/tafsir_modal_widget.dart';

class QuranReader extends StatefulWidget {
  const QuranReader({super.key});

  @override
  State<QuranReader> createState() => _QuranReaderState();
}

class _QuranReaderState extends State<QuranReader> {
  int _currentSurah = 1;
  int _currentVerse = 1;
  bool _isLoading = true;
  bool _showSearch = false;
  bool _showBookmarks = false;
  bool _showSettings = false;
  bool _showTafsir = false;
  String _selectedVerseKey = '';

  Map<String, dynamic> _quranData = {};
  List<Map<String, dynamic>> _bookmarks = [];
  String _searchQuery = '';
  double _fontSize = 18.0;
  double _lineSpacing = 1.8;
  String _selectedReciter = 'Abdul Rahman Al-Sudais';

  final Map<String, String> _reciters = {
    'Abdul Rahman Al-Sudais': 'ar.alafasy',
    'Abdul Basit': 'ar.abdulbasitmurattal',
    'Mishary Al-Afasy': 'ar.mishary',
    'Maher Al-Mueaqly': 'ar.mahermuaiqly',
    'Saad Al-Ghamdi': 'ar.saadalghamdi',
  };

  @override
  void initState() {
    super.initState();
    _loadQuranData();
    _loadBookmarks();
    _loadSettings();
  }

  Future<void> _loadQuranData() async {
    try {
      // Using mock data for demonstration - replace with actual Quran API
      final mockData = {
        'surahs': [
          {
            'number': 1,
            'name': 'الفاتحة',
            'englishName': 'Al-Fatihah',
            'verses': [
              {'number': 1, 'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'},
              {'number': 2, 'text': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'},
              {'number': 3, 'text': 'الرَّحْمَٰنِ الرَّحِيمِ'},
              {'number': 4, 'text': 'مَالِكِ يَوْمِ الدِّينِ'},
              {'number': 5, 'text': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'},
              {'number': 6, 'text': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ'},
              {
                'number': 7,
                'text':
                    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ'
              },
            ]
          },
          {
            'number': 2,
            'name': 'البقرة',
            'englishName': 'Al-Baqarah',
            'verses': [
              {'number': 1, 'text': 'الم'},
              {
                'number': 2,
                'text':
                    'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ'
              },
              {
                'number': 3,
                'text':
                    'الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ'
              },
            ]
          }
        ]
      };

      setState(() {
        _quranData = mockData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getString('quran_bookmarks');
    if (bookmarksJson != null) {
      setState(() {
        _bookmarks =
            List<Map<String, dynamic>>.from(json.decode(bookmarksJson));
      });
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran_bookmarks', json.encode(_bookmarks));
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('quran_font_size') ?? 18.0;
      _lineSpacing = prefs.getDouble('quran_line_spacing') ?? 1.8;
      _selectedReciter =
          prefs.getString('quran_reciter') ?? 'Abdul Rahman Al-Sudais';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quran_font_size', _fontSize);
    await prefs.setDouble('quran_line_spacing', _lineSpacing);
    await prefs.setString('quran_reciter', _selectedReciter);
  }

  void _toggleBookmark(int surah, int verse) {
    final verseKey = '$surah:$verse';
    final existingIndex = _bookmarks.indexWhere((b) => b['key'] == verseKey);

    if (existingIndex != -1) {
      _bookmarks.removeAt(existingIndex);
    } else {
      _bookmarks.add({
        'key': verseKey,
        'surah': surah,
        'verse': verse,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    _saveBookmarks();
    setState(() {});
  }

  void _navigateToVerse(int surah, int verse) {
    setState(() {
      _currentSurah = surah;
      _currentVerse = verse;
    });
  }

  void _showTafsirForVerse(String verseKey) {
    setState(() {
      _selectedVerseKey = verseKey;
      _showTafsir = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: _getCurrentSurahName(),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showSearch = true),
            icon: const Icon(Icons.search),
            tooltip: 'البحث في القرآن',
          ),
          IconButton(
            onPressed: () => setState(() => _showBookmarks = true),
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'العلامات المرجعية',
          ),
          IconButton(
            onPressed: () => setState(() => _showSettings = true),
            icon: const Icon(Icons.settings),
            tooltip: 'إعدادات القراءة',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Surah header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _getCurrentSurahName(),
                      style: GoogleFonts.notoSansArabic(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSurahInfo(),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Quran text
              Expanded(
                child: QuranTextWidget(
                  surahData: _getCurrentSurahData(),
                  fontSize: _fontSize,
                  lineSpacing: _lineSpacing,
                  bookmarks: _bookmarks,
                  onVerseBookmark: _toggleBookmark,
                  onVerseTap: _showTafsirForVerse,
                ),
              ),

              // Audio controls
              AudioControlsWidget(
                currentSurah: _currentSurah,
                currentVerse: _currentVerse,
                selectedReciter: _selectedReciter,
                reciters: _reciters,
                onReciterChanged: (reciter) {
                  setState(() => _selectedReciter = reciter);
                  _saveSettings();
                },
                onVerseChanged: (verse) {
                  setState(() => _currentVerse = verse);
                },
              ),
            ],
          ),

          // Overlays
          if (_showSearch)
            SearchOverlayWidget(
              quranData: _quranData,
              searchQuery: _searchQuery,
              onSearchChanged: (query) => setState(() => _searchQuery = query),
              onVerseSelected: (surah, verse) {
                _navigateToVerse(surah, verse);
                setState(() => _showSearch = false);
              },
              onClose: () => setState(() => _showSearch = false),
            ),

          if (_showBookmarks)
            BookmarkListWidget(
              bookmarks: _bookmarks,
              onBookmarkSelected: (surah, verse) {
                _navigateToVerse(surah, verse);
                setState(() => _showBookmarks = false);
              },
              onBookmarkDeleted: (index) {
                _bookmarks.removeAt(index);
                _saveBookmarks();
                setState(() {});
              },
              onClose: () => setState(() => _showBookmarks = false),
            ),

          if (_showSettings)
            SettingsOverlayWidget(
              fontSize: _fontSize,
              lineSpacing: _lineSpacing,
              onFontSizeChanged: (size) {
                setState(() => _fontSize = size);
                _saveSettings();
              },
              onLineSpacingChanged: (spacing) {
                setState(() => _lineSpacing = spacing);
                _saveSettings();
              },
              onClose: () => setState(() => _showSettings = false),
            ),

          if (_showTafsir)
            TafsirModalWidget(
              verseKey: _selectedVerseKey,
              onClose: () => setState(() => _showTafsir = false),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 4, // Assuming Quran tab is index 4
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // Navigation handled by CustomBottomBar
  }

  String _getCurrentSurahName() {
    if (_quranData['surahs']?.isNotEmpty == true) {
      final surah = _quranData['surahs'].firstWhere(
        (s) => s['number'] == _currentSurah,
        orElse: () => _quranData['surahs'][0],
      );
      return surah['name'] ?? '';
    }
    return '';
  }

  String _getSurahInfo() {
    if (_quranData['surahs']?.isNotEmpty == true) {
      final surah = _quranData['surahs'].firstWhere(
        (s) => s['number'] == _currentSurah,
        orElse: () => _quranData['surahs'][0],
      );
      final versesCount = surah['verses']?.length ?? 0;
      return '$versesCount آية • مكية'; // This should be dynamic based on actual data
    }
    return '';
  }

  Map<String, dynamic> _getCurrentSurahData() {
    if (_quranData['surahs']?.isNotEmpty == true) {
      return _quranData['surahs'].firstWhere(
        (s) => s['number'] == _currentSurah,
        orElse: () => _quranData['surahs'][0],
      );
    }
    return {};
  }
}