import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class CalibrationWidget extends StatefulWidget {
  final VoidCallback onFinish;

  const CalibrationWidget({
    super.key,
    required this.onFinish,
  });

  @override
  State<CalibrationWidget> createState() => _CalibrationWidgetState();
}

class _CalibrationWidgetState extends State<CalibrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  final int _totalSteps = 3;

  final List<String> _instructions = [
    'امسك الهاتف بشكل مستوٍ',
    'حرك الهاتف في شكل رقم 8',
    'استمر في الحركة لمدة 10 ثوانٍ',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));

    _startCalibrationSequence();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startCalibrationSequence() {
    _animationController.repeat(reverse: true);

    // Progress through steps
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentStep++;
        });

        if (_currentStep >= _totalSteps) {
          timer.cancel();
          _progressController.forward().then((_) {
            if (mounted) {
              widget.onFinish();
            }
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.95),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.tune,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'معايرة البوصلة',
                      style: theme.textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: widget.onFinish,
                      icon: const Icon(Icons.close),
                      tooltip: 'إلغاء',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Animation
                SizedBox(
                  height: 120,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _animationController,
                      _progressController,
                    ]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                            ),
                          ),

                          // Phone icon
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Icon(
                                Icons.phone_android,
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),

                          // Progress ring
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 4,
                              backgroundColor: theme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Step indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalSteps, (index) {
                    final isActive = index <= _currentStep;
                    final isCompleted = index < _currentStep;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: theme.colorScheme.onPrimary,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: GoogleFonts.inter(
                                  color: isActive
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 16),

                // Current instruction
                Text(
                  _currentStep < _totalSteps
                      ? _instructions[_currentStep]
                      : 'جاري الانتهاء من المعايرة...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Helper text
                Text(
                  _getHelperText(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Progress text
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final progress = (_progressAnimation.value * 100).round();
                    return Text(
                      '$progress%',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getHelperText() {
    switch (_currentStep) {
      case 0:
        return 'تأكد من أن الهاتف في وضع أفقي مستوٍ';
      case 1:
        return 'حرك الهاتف برفق في شكل رقم 8 في الهواء';
      case 2:
        return 'استمر في الحركة حتى انتهاء العد التنازلي';
      default:
        return 'تم الانتهاء من المعايرة بنجاح';
    }
  }
}