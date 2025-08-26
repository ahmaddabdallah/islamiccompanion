import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfoWidget extends StatelessWidget {
  final Position position;
  final double qiblaDirection;
  final double accuracy;
  final String status;

  const LocationInfoWidget({
    super.key,
    required this.position,
    required this.qiblaDirection,
    required this.accuracy,
    required this.status,
  });

  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distanceToKaaba = _calculateDistanceToKaaba();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status indicator
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getStatusColor(theme),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(theme),
                ),
              ),
              const Spacer(),
              Text(
                '${accuracy.toStringAsFixed(0)}% دقة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Location and distance info
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  theme,
                  'المسافة إلى الكعبة',
                  '${distanceToKaaba.toStringAsFixed(0)} كم',
                  Icons.place,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  theme,
                  'اتجاه القبلة',
                  '${qiblaDirection.toStringAsFixed(0)}°',
                  Icons.navigation,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Coordinates
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  theme,
                  'خط العرض',
                  position.latitude.toStringAsFixed(4),
                  Icons.location_on,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  theme,
                  'خط الطول',
                  position.longitude.toStringAsFixed(4),
                  Icons.location_on,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    if (accuracy > 80) {
      return Colors.green;
    } else if (accuracy > 60) {
      return Colors.orange;
    } else {
      return theme.colorScheme.error;
    }
  }

  double _calculateDistanceToKaaba() {
    return Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _kaabaLatitude,
          _kaabaLongitude,
        ) /
        1000; // Convert to kilometers
  }
}
