import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/counter_controls.dart';
import './widgets/counter_display.dart';
import './widgets/daily_dhikr_categories.dart';
import './widgets/dhikr_phrase_selector.dart';
import './widgets/target_progress_ring.dart';

class DhikrCounter extends StatefulWidget {
  const DhikrCounter({super.key});

  @override
  State<DhikrCounter> createState() => _DhikrCounterState();
}

class _DhikrCounterState extends State<DhikrCounter>
    with TickerProviderStateMixin {
  int _currentCount = 0;
  int _selectedPhraseIndex = 0;
  int _targetCount = 33;
  bool _isRapidMode = false;
  bool _showTargetRing = false;
  bool _showDailyCategories = false;
  bool _vibrationEnabled = true;
  bool _soundEnabled = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock data for dhikr phrases
  final List<Map<String, dynamic>> _dhikrPhrases = [
    {
      'arabic': 'سُبْحَانَ اللَّهِ',
      'transliteration': 'Subhan Allah',
      'meaning': 'Glory be to Allah',
      'count': 0,
    },
    {
      'arabic': 'الْحَمْدُ لِلَّهِ',
      'transliteration': 'Alhamdulillah',
      'meaning': 'Praise be to Allah',
      'count': 0,
    },
    {
      'arabic': 'اللَّهُ أَكْبَرُ',
      'transliteration': 'Allahu Akbar',
      'meaning': 'Allah is Greatest',
      'count': 0,
    },
    {
      'arabic': 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      'transliteration': 'La ilaha illa Allah',
      'meaning': 'There is no god but Allah',
      'count': 0,
    },
    {
      'arabic': 'أَسْتَغْفِرُ اللَّهَ',
      'transliteration': 'Astaghfirullah',
      'meaning': 'I seek forgiveness from Allah',
      'count': 0,
    },
  ];

  // Mock data for daily dhikr categories
  final List<Map<String, dynamic>> _dailyCategories = [
    {
      'id': 'morning',
      'title': 'Morning Azkar',
      'description': 'Start your day with remembrance of Allah',
      'icon': 'wb_sunny',
      'completed': false,
      'completionPercentage': 0.0,
      'totalCount': 100,
      'currentCount': 0,
    },
    {
      'id': 'evening',
      'title': 'Evening Dhikr',
      'description': 'End your day with gratitude and remembrance',
      'icon': 'nights_stay',
      'completed': false,
      'completionPercentage': 0.3,
      'totalCount': 100,
      'currentCount': 30,
    },
    {
      'id': 'sleep',
      'title': 'Before Sleep',
      'description': 'Peaceful dhikr for restful sleep',
      'icon': 'bedtime',
      'completed': true,
      'completionPercentage': 1.0,
      'totalCount': 33,
      'currentCount': 33,
    },
    {
      'id': 'after_prayer',
      'title': 'After Prayer',
      'description': 'Continue worship after Salah',
      'icon': 'mosque',
      'completed': false,
      'completionPercentage': 0.6,
      'totalCount': 99,
      'currentCount': 59,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSavedData();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _currentCount =
            prefs.getInt('dhikr_count_${_selectedPhraseIndex}') ?? 0;
        _selectedPhraseIndex = prefs.getInt('selected_phrase_index') ?? 0;
        _targetCount = prefs.getInt('target_count') ?? 33;
        _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
        _soundEnabled = prefs.getBool('sound_enabled') ?? false;
      });

      // Load individual phrase counts
      for (int i = 0; i < _dhikrPhrases.length; i++) {
        _dhikrPhrases[i]['count'] = prefs.getInt('dhikr_count_$i') ?? 0;
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dhikr_count_${_selectedPhraseIndex}', _currentCount);
      await prefs.setInt('selected_phrase_index', _selectedPhraseIndex);
      await prefs.setInt('target_count', _targetCount);
      await prefs.setBool('vibration_enabled', _vibrationEnabled);
      await prefs.setBool('sound_enabled', _soundEnabled);

      // Save individual phrase counts
      for (int i = 0; i < _dhikrPhrases.length; i++) {
        await prefs.setInt('dhikr_count_$i', _dhikrPhrases[i]['count'] as int);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _incrementCounter() {
    setState(() {
      _currentCount++;
      _dhikrPhrases[_selectedPhraseIndex]['count'] = _currentCount;
    });

    if (_vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    _saveData();

    // Check if target reached
    if (_currentCount == _targetCount) {
      _showTargetReachedDialog();
    }
  }

  void _resetCounter() {
    setState(() {
      _currentCount = 0;
      _dhikrPhrases[_selectedPhraseIndex]['count'] = 0;
    });
    _saveData();
  }

  void _selectPhrase(int index) {
    setState(() {
      _selectedPhraseIndex = index;
      _currentCount = _dhikrPhrases[index]['count'] as int;
    });
    _saveData();
  }

  void _toggleRapidMode() {
    setState(() {
      _isRapidMode = !_isRapidMode;
    });
    HapticFeedback.mediumImpact();
  }

  void _toggleTargetRing() {
    setState(() {
      _showTargetRing = !_showTargetRing;
    });
  }

  void _showTargetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        int tempTarget = _targetCount;

        return AlertDialog(
          title: Text(
            'Set Target Count',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose your dhikr target:',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 2.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: [33, 99, 100, 500, 1000].map((count) {
                  return GestureDetector(
                    onTap: () => tempTarget = count,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: tempTarget == count
                            ? AppTheme.lightTheme.colorScheme.primary
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: tempTarget == count
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _targetCount = tempTarget;
                });
                _saveData();
                Navigator.of(context).pop();
              },
              child: Text('Set Target'),
            ),
          ],
        );
      },
    );
  }

  void _showTargetReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);

        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Target Reached!',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Text(
            'Congratulations! You have completed $_targetCount dhikr. May Allah accept your remembrance.',
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCounter();
              },
              child: Text('Reset & Start Again'),
            ),
          ],
        );
      },
    );
  }

  void _toggleDailyCategories() {
    setState(() {
      _showDailyCategories = !_showDailyCategories;
    });

    if (_showDailyCategories) {
      _slideController.forward();
    } else {
      _slideController.reverse();
    }
  }

  void _selectDailyCategory(Map<String, dynamic> category) {
    // Handle daily category selection
    setState(() {
      _showDailyCategories = false;
    });
    _slideController.reverse();

    // Show category details or navigate to specific dhikr
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${category['title']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Dhikr Counter',
        variant: CustomAppBarVariant.standard,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _showTargetRing ? 'visibility_off' : 'visibility',
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            onPressed: _toggleTargetRing,
            tooltip: 'Toggle Target Ring',
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! < -500) {
              // Swipe up - show additional controls
              _toggleTargetRing();
            } else if (details.primaryVelocity! > 500) {
              // Swipe down - show daily categories
              _toggleDailyCategories();
            }
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                // Phrase Selector
                DhikrPhraseSelector(
                  phrases: _dhikrPhrases,
                  selectedIndex: _selectedPhraseIndex,
                  onPhraseSelected: _selectPhrase,
                ),

                // Counter Area
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Target Progress Ring (behind counter)
                      if (_showTargetRing)
                        TargetProgressRing(
                          currentCount: _currentCount,
                          targetCount: _targetCount,
                          onTargetTap: _showTargetDialog,
                          isVisible: _showTargetRing,
                        ),

                      // Main Counter Display
                      CounterDisplay(
                        count: _currentCount,
                        onTap: _incrementCounter,
                        onLongPress: _toggleRapidMode,
                        isRapidMode: _isRapidMode,
                      ),
                    ],
                  ),
                ),

                // Counter Controls
                CounterControls(
                  onReset: _resetCounter,
                  onHistory: () {
                    // Navigate to history screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('History feature coming soon')),
                    );
                  },
                  onSettings: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  currentCount: _currentCount,
                ),

                SizedBox(height: 2.h),
              ],
            ),

            // Daily Categories Slide-up Panel
            if (_showDailyCategories)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: DailyDhikrCategories(
                    categories: _dailyCategories,
                    onCategorySelected: _selectDailyCategory,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 2, // Dhikr tab index
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
