import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  bool _showOfflineOption = false;
  bool _isInitializing = true;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    // Background color animation
    _backgroundColorAnimation = ColorTween(
      begin: AppTheme.primaryLight,
      end: AppTheme.backgroundLight,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _backgroundAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.primaryLight,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryLight,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Initialize prayer time data for Cairo
      await _loadPrayerTimeData();

      // Cache Quran content
      await _cacheQuranContent();

      // Initialize audio components
      await _initializeAudioComponents();

      // Prepare daily azkar
      await _prepareDailyAzkar();

      // Setup timeout for offline option
      _setupOfflineTimeout();

      // Navigate to home dashboard after successful initialization
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        setState(() {
          _loadingText = 'Preparing offline content...';
        });
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    }
  }

  Future<void> _loadPrayerTimeData() async {
    setState(() {
      _loadingText = 'Loading prayer times...';
    });

    // Simulate loading prayer time data for Cairo, Egypt
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real implementation, this would:
    // - Calculate prayer times based on Cairo coordinates
    // - Cache the data locally for offline access
    // - Set up automatic daily updates
  }

  Future<void> _cacheQuranContent() async {
    setState(() {
      _loadingText = 'Caching Quran content...';
    });

    // Simulate caching Quran content
    await Future.delayed(const Duration(milliseconds: 600));

    // In a real implementation, this would:
    // - Download and cache Quran text in Arabic
    // - Prepare search indices for keyword search
    // - Cache audio files for offline recitation
  }

  Future<void> _initializeAudioComponents() async {
    setState(() {
      _loadingText = 'Initializing audio...';
    });

    // Simulate audio component initialization
    await Future.delayed(const Duration(milliseconds: 400));

    // In a real implementation, this would:
    // - Initialize audio player for Quran recitation
    // - Set up audio session for background playback
    // - Prepare audio caching system
  }

  Future<void> _prepareDailyAzkar() async {
    setState(() {
      _loadingText = 'Preparing daily azkar...';
    });

    // Simulate preparing daily azkar content
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real implementation, this would:
    // - Load morning, evening, and sleep azkar
    // - Prepare after-prayer azkar content
    // - Set up notification scheduling
  }

  void _setupOfflineTimeout() {
    // Show offline option after 5 seconds if still loading
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isInitializing) {
        setState(() {
          _showOfflineOption = true;
        });
      }
    });
  }

  void _continueOffline() {
    setState(() {
      _isInitializing = false;
    });
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundColorAnimation.value ?? AppTheme.primaryLight,
                  AppTheme.backgroundLight,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Main content area
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo and app name section
                          AnimatedBuilder(
                            animation: _logoAnimationController,
                            builder: (context, child) {
                              return FadeTransition(
                                opacity: _logoFadeAnimation,
                                child: ScaleTransition(
                                  scale: _logoScaleAnimation,
                                  child: Column(
                                    children: [
                                      // Islamic geometric pattern / App logo
                                      Container(
                                        width: 25.w,
                                        height: 25.w,
                                        decoration: BoxDecoration(
                                          color: AppTheme.backgroundLight,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'mosque',
                                            size: 15.w,
                                            color: AppTheme.primaryLight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3.h),

                                      // App name
                                      Text(
                                        'Islamic Companion',
                                        style: AppTheme
                                            .lightTheme.textTheme.headlineMedium
                                            ?.copyWith(
                                          color: AppTheme.backgroundLight,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 1.h),

                                      // Subtitle
                                      Text(
                                        'Your Daily Spiritual Guide',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: AppTheme.backgroundLight
                                              .withValues(alpha: 0.9),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 8.h),

                          // Loading indicator and text
                          if (_isInitializing) ...[
                            SizedBox(
                              width: 8.w,
                              height: 8.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.backgroundLight,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _loadingText,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.backgroundLight
                                    .withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom section with offline option
                  if (_showOfflineOption)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      child: Column(
                        children: [
                          Text(
                            'Taking longer than expected?',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.backgroundLight
                                  .withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _continueOffline,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.backgroundLight,
                                foregroundColor: AppTheme.primaryLight,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Continue Offline',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Bottom padding for safe area
                  if (!_showOfflineOption) SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
