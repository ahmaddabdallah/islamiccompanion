import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/calibration_widget.dart';
import './widgets/compass_widget.dart';
import './widgets/location_info_widget.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key});

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double _qiblaDirection = 0.0;
  double _currentDirection = 0.0;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _hasLocationPermission = false;
  bool _hasLocationService = false;
  bool _showCalibration = false;
  double _accuracy = 0.0;
  String _compassStatus = 'جاري التحميل...';

  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  List<double> _magnetometerReadings = [];
  List<double> _accelerometerReadings = [];

  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  @override
  void initState() {
    super.initState();
    _initializeCompass();
  }

  @override
  void dispose() {
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeCompass() async {
    try {
      await _checkPermissions();
      if (_hasLocationPermission && _hasLocationService) {
        await _getCurrentLocation();
        _startSensorListening();
      } else {
        setState(() {
          _isLoading = false;
          _compassStatus = 'تحتاج إلى إذن الموقع';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _compassStatus = 'خطأ في تحديد الموقع';
      });
    }
  }

  Future<void> _checkPermissions() async {
    // Check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _hasLocationService = false;
        _compassStatus = 'خدمة الموقع غير مفعلة';
      });
      return;
    }

    setState(() => _hasLocationService = true);

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _hasLocationPermission = false;
          _compassStatus = 'تم رفض إذن الموقع';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _hasLocationPermission = false;
        _compassStatus = 'إذن الموقع مرفوض نهائياً';
      });
      return;
    }

    setState(() => _hasLocationPermission = true);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _qiblaDirection = _calculateQiblaDirection(position);
      });
    } catch (e) {
      // Use Cairo, Egypt as fallback location
      setState(() {
        _currentPosition = Position(
          latitude: 30.0444,
          longitude: 31.2357,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        _qiblaDirection = _calculateQiblaDirection(_currentPosition!);
        _compassStatus = 'تم استخدام موقع افتراضي (القاهرة)';
      });
    }
  }

  double _calculateQiblaDirection(Position userLocation) {
    double userLat = _degreesToRadians(userLocation.latitude);
    double userLon = _degreesToRadians(userLocation.longitude);
    double kaabaLat = _degreesToRadians(_kaabaLatitude);
    double kaabaLon = _degreesToRadians(_kaabaLongitude);

    double deltaLon = kaabaLon - userLon;

    double y = sin(deltaLon) * cos(kaabaLat);
    double x = cos(userLat) * sin(kaabaLat) -
        sin(userLat) * cos(kaabaLat) * cos(deltaLon);

    double bearing = atan2(y, x);
    bearing = _radiansToDegrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double _radiansToDegrees(double radians) {
    return radians * 180 / pi;
  }

  void _startSensorListening() {
    // Listen to magnetometer for compass direction
    _magnetometerSubscription = magnetometerEventStream().listen(
      (MagnetometerEvent event) {
        _magnetometerReadings.add(event.x);
        _magnetometerReadings.add(event.y);
        _magnetometerReadings.add(event.z);

        // Keep only recent readings for stability
        if (_magnetometerReadings.length > 30) {
          _magnetometerReadings = _magnetometerReadings.sublist(15);
        }

        _updateCompassDirection();
      },
    );

    // Listen to accelerometer for device orientation
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _accelerometerReadings.add(event.x);
        _accelerometerReadings.add(event.y);
        _accelerometerReadings.add(event.z);

        if (_accelerometerReadings.length > 30) {
          _accelerometerReadings = _accelerometerReadings.sublist(15);
        }
      },
    );

    setState(() {
      _isLoading = false;
      _compassStatus = 'البوصلة جاهزة';
    });
  }

  void _updateCompassDirection() {
    if (_magnetometerReadings.length < 3) return;

    // Simple compass calculation using magnetometer
    double x = _magnetometerReadings[_magnetometerReadings.length - 3];
    double y = _magnetometerReadings[_magnetometerReadings.length - 2];

    double direction = atan2(y, x) * 180 / pi;
    direction = (direction + 360) % 360;

    setState(() {
      _currentDirection = direction;
      _accuracy = _calculateAccuracy();
      _updateCompassStatus();
    });
  }

  double _calculateAccuracy() {
    if (_magnetometerReadings.length < 15) return 0.0;

    // Calculate stability of readings
    var recent =
        _magnetometerReadings.sublist(_magnetometerReadings.length - 15);
    double variance = 0.0;
    double mean = recent.reduce((a, b) => a + b) / recent.length;

    for (double reading in recent) {
      variance += pow(reading - mean, 2);
    }
    variance /= recent.length;

    // Convert variance to accuracy percentage (lower variance = higher accuracy)
    return (100 - (variance * 10)).clamp(0.0, 100.0);
  }

  void _updateCompassStatus() {
    if (_accuracy > 80) {
      _compassStatus = 'دقة عالية';
    } else if (_accuracy > 60) {
      _compassStatus = 'دقة متوسطة';
    } else if (_accuracy > 40) {
      _compassStatus = 'دقة منخفضة - معايرة مطلوبة';
    } else {
      _compassStatus = 'معايرة مطلوبة';
    }
  }

  double get _qiblaAngle {
    if (_currentPosition == null) return 0.0;
    return (_qiblaDirection - _currentDirection + 360) % 360;
  }

  bool get _isAlignedWithQibla {
    double angle = _qiblaAngle;
    return (angle < 10 || angle > 350);
  }

  void _startCalibration() {
    setState(() => _showCalibration = true);
  }

  void _finishCalibration() {
    setState(() => _showCalibration = false);
    // Reset readings for fresh start
    _magnetometerReadings.clear();
    _accelerometerReadings.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'بوصلة القبلة'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                _compassStatus,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'بوصلة القبلة',
        actions: [
          IconButton(
            onPressed: _startCalibration,
            icon: const Icon(Icons.tune),
            tooltip: 'معايرة البوصلة',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Location info
              if (_currentPosition != null)
                LocationInfoWidget(
                  position: _currentPosition!,
                  qiblaDirection: _qiblaDirection,
                  accuracy: _accuracy,
                  status: _compassStatus,
                ),

              // Compass
              Expanded(
                child: CompassWidget(
                  qiblaAngle: _qiblaAngle,
                  currentDirection: _currentDirection,
                  isAligned: _isAlignedWithQibla,
                  accuracy: _accuracy,
                ),
              ),

              // Status and instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                  children: [
                    // Alignment indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isAlignedWithQibla
                            ? Colors.green.withValues(alpha: 0.1)
                            : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isAlignedWithQibla
                                ? Icons.check_circle
                                : Icons.navigation,
                            color: _isAlignedWithQibla
                                ? Colors.green
                                : theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isAlignedWithQibla
                                ? 'متجه نحو القبلة'
                                : 'حرك الجهاز نحو اتجاه القبلة',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _isAlignedWithQibla
                                  ? Colors.green
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Instructions
                    Text(
                      'امسك الجهاز بشكل مستوٍ وحرك في شكل رقم 8 للمعايرة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Calibration overlay
          if (_showCalibration)
            CalibrationWidget(
              onFinish: _finishCalibration,
            ),

          // Error states
          if (!_hasLocationPermission || !_hasLocationService)
            _buildErrorOverlay(context),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 5, // Assuming Qibla tab is index 5
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildErrorOverlay(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_off,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'خطأ في الموقع',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _compassStatus,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _isLoading = true);
                    _initializeCompass();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // Navigation handled by CustomBottomBar
  }
}