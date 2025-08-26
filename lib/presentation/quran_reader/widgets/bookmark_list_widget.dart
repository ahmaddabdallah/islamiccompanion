import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookmarkListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> bookmarks;
  final Function(int, int) onBookmarkSelected;
  final Function(int) onBookmarkDeleted;
  final VoidCallback onClose;

  const BookmarkListWidget({
    super.key,
    required this.bookmarks,
    required this.onBookmarkSelected,
    required this.onBookmarkDeleted,
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
                    'العلامات المرجعية',
                    style: theme.textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (bookmarks.isNotEmpty)
                    Text(
                      '${bookmarks.length} علامة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Bookmarks list
            Expanded(
              child: bookmarks.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookmarks.length,
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        final surahNumber = bookmark['surah'] as int;
                        final verseNumber = bookmark['verse'] as int;
                        final timestamp = DateTime.tryParse(
                            bookmark['timestamp'] as String? ?? '');

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () =>
                                onBookmarkSelected(surahNumber, verseNumber),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Bookmark icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.bookmark,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                      size: 20,
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Bookmark info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getSurahName(surahNumber),
                                          style: GoogleFonts.notoSansArabic(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'آية $verseNumber',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                        if (timestamp != null)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              _formatTimestamp(timestamp),
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme
                                                    .colorScheme.onSurface
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Delete button
                                  IconButton(
                                    onPressed: () =>
                                        _showDeleteDialog(context, index),
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'حذف العلامة',
                                    style: IconButton.styleFrom(
                                      foregroundColor: theme.colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
            Icons.bookmark_border,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد علامات مرجعية',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على رمز العلامة بجانب أي آية لحفظها هنا',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getSurahName(int surahNumber) {
    // In a real implementation, this would fetch the actual surah name
    final surahNames = {
      1: 'الفاتحة',
      2: 'البقرة',
      3: 'آل عمران',
      4: 'النساء',
      5: 'المائدة',
      // Add more surah names...
    };
    return surahNames[surahNumber] ?? 'سورة $surahNumber';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العلامة المرجعية'),
        content: const Text('هل أنت متأكد من حذف هذه العلامة المرجعية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onBookmarkDeleted(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
