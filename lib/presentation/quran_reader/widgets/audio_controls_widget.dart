import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioControlsWidget extends StatefulWidget {
  final int currentSurah;
  final int currentVerse;
  final String selectedReciter;
  final Map<String, String> reciters;
  final Function(String) onReciterChanged;
  final Function(int) onVerseChanged;

  const AudioControlsWidget({
    super.key,
    required this.currentSurah,
    required this.currentVerse,
    required this.selectedReciter,
    required this.reciters,
    required this.onReciterChanged,
    required this.onVerseChanged,
  });

  @override
  State<AudioControlsWidget> createState() => _AudioControlsWidgetState();
}

class _AudioControlsWidgetState extends State<AudioControlsWidget> {
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _isExpanded = false;
  bool _repeatMode = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 2,
          ),

          // Main controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Previous verse button
                IconButton(
                  onPressed: _previousVerse,
                  icon: const Icon(Icons.skip_previous),
                  tooltip: 'الآية السابقة',
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                  ),
                ),

                // Play/Pause button
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: _isLoading
                      ? SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                          ),
                        )
                      : IconButton(
                          onPressed: _togglePlayPause,
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 32,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.all(8),
                            minimumSize: const Size(48, 48),
                          ),
                          tooltip: _isPlaying ? 'توقف' : 'تشغيل',
                        ),
                ),

                // Next verse button
                IconButton(
                  onPressed: _nextVerse,
                  icon: const Icon(Icons.skip_next),
                  tooltip: 'الآية التالية',
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                  ),
                ),

                const Spacer(),

                // Current verse info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'آية ${widget.currentVerse}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.selectedReciter,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),

                // Expand/collapse button
                IconButton(
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  tooltip: _isExpanded ? 'إخفاء الخيارات' : 'إظهار الخيارات',
                ),
              ],
            ),
          ),

          // Extended controls
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ),
              child: Column(
                children: [
                  // Repeat and reciter controls
                  Row(
                    children: [
                      // Repeat mode toggle
                      IconButton(
                        onPressed: () =>
                            setState(() => _repeatMode = !_repeatMode),
                        icon: Icon(
                          _repeatMode ? Icons.repeat_one : Icons.repeat,
                          color: _repeatMode ? theme.colorScheme.primary : null,
                        ),
                        tooltip: _repeatMode ? 'إيقاف التكرار' : 'تكرار الآية',
                      ),

                      const SizedBox(width: 16),

                      // Reciter dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: widget.selectedReciter,
                          decoration: InputDecoration(
                            labelText: 'القارئ',
                            labelStyle: GoogleFonts.inter(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: widget.reciters.keys.map((reciter) {
                            return DropdownMenuItem<String>(
                              value: reciter,
                              child: Text(
                                reciter,
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (reciter) {
                            if (reciter != null) {
                              widget.onReciterChanged(reciter);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Download options (mock)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _downloadSurah,
                          icon: const Icon(Icons.download, size: 16),
                          label: Text(
                            'تحميل السورة',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _downloadVerse,
                          icon: const Icon(Icons.download, size: 16),
                          label: Text(
                            'تحميل الآية',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
      } else {
        _isLoading = true;
        // Simulate loading
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _isPlaying = true;
            });
            _startProgressAnimation();
          }
        });
      }
    });
  }

  void _startProgressAnimation() {
    // Mock progress animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isPlaying && _progress < 1.0) {
        setState(() {
          _progress += 0.01;
        });
        _startProgressAnimation();
      }
    });
  }

  void _previousVerse() {
    if (widget.currentVerse > 1) {
      widget.onVerseChanged(widget.currentVerse - 1);
      _resetAudio();
    }
  }

  void _nextVerse() {
    widget.onVerseChanged(widget.currentVerse + 1);
    _resetAudio();
  }

  void _resetAudio() {
    setState(() {
      _isPlaying = false;
      _progress = 0.0;
    });
  }

  void _downloadSurah() {
    // Mock download implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بدء تحميل السورة...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadVerse() {
    // Mock download implementation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('بدء تحميل الآية...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
