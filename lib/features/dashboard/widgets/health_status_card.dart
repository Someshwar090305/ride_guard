import 'package:flutter/material.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/data/models/health_status.dart';

class HealthStatusCard extends StatelessWidget {
  final HealthStatus healthStatus;

  const HealthStatusCard({
    super.key,
    required this.healthStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getGradient(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bike Health',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusText(),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Message
            Text(
              healthStatus.message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.notifications_active,
                    healthStatus.alertCount.toString(),
                    'Alerts Today',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.error_outline,
                    healthStatus.issues.length.toString(),
                    'Issues Found',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getColor() {
    switch (healthStatus.level) {
      case HealthLevel.normal:
        return AppColors.success;
      case HealthLevel.warning:
        return AppColors.warning;
      case HealthLevel.critical:
        return AppColors.critical;
    }
  }

  LinearGradient _getGradient() {
    switch (healthStatus.level) {
      case HealthLevel.normal:
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case HealthLevel.warning:
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFA726)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case HealthLevel.critical:
        return const LinearGradient(
          colors: [Color(0xFFF44336), Color(0xFFE57373)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Widget _getIcon() {
    IconData iconData;
    switch (healthStatus.level) {
      case HealthLevel.normal:
        iconData = Icons.check_circle;
        break;
      case HealthLevel.warning:
        iconData = Icons.warning_amber_rounded;
        break;
      case HealthLevel.critical:
        iconData = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  String _getStatusText() {
    switch (healthStatus.level) {
      case HealthLevel.normal:
        return 'Normal';
      case HealthLevel.warning:
        return 'Warning';
      case HealthLevel.critical:
        return 'Critical';
    }
  }
}