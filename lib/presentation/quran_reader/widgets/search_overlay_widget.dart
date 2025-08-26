import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchOverlayWidget extends StatefulWidget {
  final Map<String, dynamic> quranData;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function(int, int) onVerseSelected;
  final VoidCallback onClose;

  const SearchOverlayWidget({
    super.key,
    required this.quranData,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onVerseSelected,
    required this.onClose,
  });

  @override
  State<SearchOverlayWidget> createState() => _SearchOverlayWidgetState();
}

class _SearchOverlayWidgetState extends State<SearchOverlayWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _searchFocusNode.requestFocus();
    if (widget.searchQuery.isNotEmpty) {
      _performSearch(widget.searchQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = <Map<String, dynamic>>[];
      final surahs = widget.quranData['surahs'] as List<dynamic>? ?? [];

      for (final surah in surahs) {
        final surahNumber = surah['number'] as int;
        final surahName = surah['name'] as String;
        final verses = surah['verses'] as List<dynamic>? ?? [];

        for (final verse in verses) {
          final verseNumber = verse['number'] as int;
          final verseText = verse['text'] as String;

          if (verseText.contains(query)) {
            results.add({
              'surah': surahNumber,
              'surahName': surahName,
              'verse': verseNumber,
              'text': verseText,
              'highlight': _highlightSearchTerm(verseText, query),
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  String _highlightSearchTerm(String text, String term) {
    // In a real implementation, this would return rich text with highlighting
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.95),
      child: SafeArea(
        child: Column(
          children: [
            // Search header
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
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'إغلاق البحث',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'ابحث في القرآن الكريم...',
                        hintStyle: GoogleFonts.notoSansArabic(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  widget.onSearchChanged('');
                                  _performSearch('');
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : const Icon(Icons.search),
                      ),
                      style: GoogleFonts.notoSansArabic(
                        fontSize: 16,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      onChanged: (value) {
                        widget.onSearchChanged(value);
                        _performSearch(value);
                      },
                      onSubmitted: _performSearch,
                    ),
                  ),
                ],
              ),
            ),

            // Search results
            Expanded(
              child: _isSearching
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'جاري البحث...',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                      ? _buildEmptyState(theme)
                      : _buildSearchResults(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            widget.searchQuery.isEmpty
                ? 'ابدأ بالبحث في القرآن الكريم'
                : 'لا توجد نتائج للبحث',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'جرب كلمات مختلفة أو تأكد من الإملاء',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final surahNumber = result['surah'] as int;
        final surahName = result['surahName'] as String;
        final verseNumber = result['verse'] as int;
        final verseText = result['text'] as String;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => widget.onVerseSelected(surahNumber, verseNumber),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Verse reference
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$surahName • آية $verseNumber',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Verse text
                  Text(
                    verseText,
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 16,
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
        );
      },
    );
  }
}
