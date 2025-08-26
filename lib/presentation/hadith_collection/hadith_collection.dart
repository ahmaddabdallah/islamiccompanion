import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_tab_widget.dart';
import './widgets/hadith_card_widget.dart';
import './widgets/hadith_detail_modal.dart';
import './widgets/hadith_preview_widget.dart';
import './widgets/search_bar_widget.dart';

class HadithCollection extends StatefulWidget {
  const HadithCollection({super.key});

  @override
  State<HadithCollection> createState() => _HadithCollectionState();
}

class _HadithCollectionState extends State<HadithCollection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentBottomIndex = 3;
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  bool _isSearching = false;
  final Set<int> _bookmarkedHadiths = {};

  final List<String> _categories = [
    'Faith',
    'Prayer',
    'Character',
    'Knowledge'
  ];

  // Mock hadith data
  final List<Map<String, dynamic>> _hadithData = [
    {
      "id": 1,
      "category": "Faith",
      "arabicText":
          "عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: الْإِيمَانُ بِضْعٌ وَسَبْعُونَ شُعْبَةً، فَأَفْضَلُهَا قَوْلُ لَا إِلَهَ إِلَّا اللَّهُ، وَأَدْنَاهَا إِمَاطَةُ الْأَذَى عَنِ الطَّرِيقِ، وَالْحَيَاءُ شُعْبَةٌ مِنَ الْإِيمَانِ",
      "englishTranslation":
          "Abu Hurairah (may Allah be pleased with him) reported: The Messenger of Allah (peace be upon him) said: Faith has over seventy branches, the most excellent of which is the declaration that there is no god but Allah, and the humblest of which is the removal of what is injurious from the path, and modesty is a branch of faith.",
      "source": "Sahih Muslim, Book 1, Hadith 63",
      "narrator": "Abu Hurairah",
      "isDaily": true,
    },
    {
      "id": 2,
      "category": "Prayer",
      "arabicText":
          "عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ أَنَّ رَسُولَ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ: أَوَّلُ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ مِنْ عَمَلِهِ صَلَاتُهُ",
      "englishTranslation":
          "Abu Hurairah (may Allah be pleased with him) reported that the Messenger of Allah (peace be upon him) said: The first thing about which a person will be questioned on the Day of Resurrection will be his prayer.",
      "source": "Sunan an-Nasa'i, Book 5, Hadith 465",
      "narrator": "Abu Hurairah",
      "isDaily": false,
    },
    {
      "id": 3,
      "category": "Character",
      "arabicText":
          "عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: إِنَّمَا بُعِثْتُ لِأُتَمِّمَ مَكَارِمَ الْأَخْلَاقِ",
      "englishTranslation":
          "Abu Hurairah (may Allah be pleased with him) reported: The Messenger of Allah (peace be upon him) said: I have been sent to perfect good character.",
      "source": "Musnad Ahmad, Hadith 8595",
      "narrator": "Abu Hurairah",
      "isDaily": false,
    },
    {
      "id": 4,
      "category": "Knowledge",
      "arabicText":
          "عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قَالَ: قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ",
      "englishTranslation":
          "Abu Hurairah (may Allah be pleased with him) reported: The Messenger of Allah (peace be upon him) said: Whoever travels a path in search of knowledge, Allah will make easy for him a path to Paradise.",
      "source": "Sahih Muslim, Book 35, Hadith 6518",
      "narrator": "Abu Hurairah",
      "isDaily": false,
    },
    {
      "id": 5,
      "category": "Faith",
      "arabicText":
          "عَنْ عُمَرَ بْنِ الْخَطَّابِ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَمِعْتُ رَسُولَ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ يَقُولُ: إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
      "englishTranslation":
          "Umar ibn al-Khattab (may Allah be pleased with him) reported: I heard the Messenger of Allah (peace be upon him) say: Actions are but by intention.",
      "source": "Sahih al-Bukhari, Book 1, Hadith 1",
      "narrator": "Umar ibn al-Khattab",
      "isDaily": false,
    },
    {
      "id": 6,
      "category": "Prayer",
      "arabicText":
          "عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ رَضِيَ اللَّهُ عَنْهُ قَالَ: سَأَلْتُ النَّبِيَّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: أَيُّ الْعَمَلِ أَحَبُّ إِلَى اللَّهِ؟ قَالَ: الصَّلَاةُ عَلَى وَقْتِهَا",
      "englishTranslation":
          "Abdullah ibn Mas'ud (may Allah be pleased with him) reported: I asked the Prophet (peace be upon him): Which deed is most beloved to Allah? He said: Prayer at its proper time.",
      "source": "Sahih al-Bukhari, Book 10, Hadith 505",
      "narrator": "Abdullah ibn Mas'ud",
      "isDaily": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Daily Hadith',
        variant: CustomAppBarVariant.standard,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: _isSearching ? 'close' : 'search',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: _isSearching ? 'Close Search' : 'Search Hadiths',
          ),
          IconButton(
            onPressed: _refreshDailyHadith,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            tooltip: 'New Daily Hadith',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            if (_isSearching) _buildSearchSection(),
            _buildDailyHadithSection(),
            _buildCategoryTabs(),
            Expanded(
              child: _buildHadithList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildSearchSection() {
    return SearchBarWidget(
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.toLowerCase();
        });
      },
      hintText: 'Search hadiths in Arabic or English...',
    );
  }

  Widget _buildDailyHadithSection() {
    final dailyHadith = _hadithData.firstWhere(
      (hadith) => hadith['isDaily'] == true,
      orElse: () => _hadithData.first,
    );

    return HadithCardWidget(
      hadith: dailyHadith,
      isBookmarked: _bookmarkedHadiths.contains(dailyHadith['id']),
      onBookmark: () => _toggleBookmark(dailyHadith['id'] as int),
      onShare: () => _shareHadith(dailyHadith),
    );
  }

  Widget _buildCategoryTabs() {
    if (_isSearching && _searchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return CategoryTabWidget(
      categories: _categories,
      selectedIndex: _selectedCategoryIndex,
      onCategorySelected: (index) {
        setState(() {
          _selectedCategoryIndex = index;
        });
        _tabController.animateTo(index);
      },
    );
  }

  Widget _buildHadithList() {
    final filteredHadiths = _getFilteredHadiths();

    if (filteredHadiths.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 2.h),
      itemCount: filteredHadiths.length,
      itemBuilder: (context, index) {
        final hadith = filteredHadiths[index];

        return HadithPreviewWidget(
          hadith: hadith,
          onTap: () => _showHadithDetail(hadith),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No hadiths found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search terms',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredHadiths() {
    List<Map<String, dynamic>> hadiths =
        _hadithData.where((hadith) => hadith['isDaily'] != true).toList();

    if (_isSearching && _searchQuery.isNotEmpty) {
      hadiths = hadiths.where((hadith) {
        final arabicText = (hadith['arabicText'] as String).toLowerCase();
        final englishText =
            (hadith['englishTranslation'] as String).toLowerCase();
        final source = (hadith['source'] as String).toLowerCase();

        return arabicText.contains(_searchQuery) ||
            englishText.contains(_searchQuery) ||
            source.contains(_searchQuery);
      }).toList();
    } else {
      final selectedCategory = _categories[_selectedCategoryIndex];
      hadiths = hadiths
          .where((hadith) => hadith['category'] == selectedCategory)
          .toList();
    }

    return hadiths;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
      }
    });
  }

  void _refreshDailyHadith() {
    // Simulate getting a new daily hadith
    final nonDailyHadiths =
        _hadithData.where((h) => h['isDaily'] != true).toList();
    if (nonDailyHadiths.isNotEmpty) {
      setState(() {
        // Reset all hadiths to non-daily
        for (var hadith in _hadithData) {
          hadith['isDaily'] = false;
        }
        // Set a random hadith as daily
        final randomIndex =
            DateTime.now().millisecondsSinceEpoch % nonDailyHadiths.length;
        nonDailyHadiths[randomIndex]['isDaily'] = true;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New daily hadith loaded'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshDailyHadith();
  }

  void _toggleBookmark(int hadithId) {
    setState(() {
      if (_bookmarkedHadiths.contains(hadithId)) {
        _bookmarkedHadiths.remove(hadithId);
      } else {
        _bookmarkedHadiths.add(hadithId);
      }
    });

    HapticFeedback.lightImpact();

    final isBookmarked = _bookmarkedHadiths.contains(hadithId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isBookmarked ? 'Hadith bookmarked' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareHadith(Map<String, dynamic> hadith) {
    final formattedText = '''
${hadith['arabicText']}

${hadith['englishTranslation']}

Source: ${hadith['source']}

Shared from IslamicCompanion App
''';

    // Copy to clipboard as sharing functionality
    Clipboard.setData(ClipboardData(text: formattedText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hadith copied to clipboard for sharing'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showHadithDetail(Map<String, dynamic> hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HadithDetailModal(
        hadith: hadith,
        isBookmarked: _bookmarkedHadiths.contains(hadith['id']),
        onBookmark: () => _toggleBookmark(hadith['id'] as int),
        onShare: () => _shareHadith(hadith),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });
  }
}