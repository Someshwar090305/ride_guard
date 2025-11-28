import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/anomaly_alert.dart';
import 'package:ride_guard/features/alerts/screens/alert_detail_screen.dart';

class RecentAlertsWidget extends StatelessWidget {
  final List<AnomalyAlert> alerts;

  const RecentAlertsWidget({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.success.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No Recent Alerts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your bike is running smoothly',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(context, alert);
      },
    );
  }

  Widget _buildAlertCard(BuildContext context, AnomalyAlert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlertDetailScreen(alert: alert),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Severity indicator
              _buildSeverityIndicator(alert.severity),
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.topCause?.name ?? 'Unknown Issue',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (alert.topCause != null) ...[
                      const SizedBox(height: 8),
                      _buildProbabilityBar(
                        context,
                        alert.topCause!.probability,
                        alert.severity,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityIndicator(AlertSeverity severity) {
    Color color;
    IconData icon;

    switch (severity) {
      case AlertSeverity.critical:
        color = AppColors.severityCritical;
        icon = Icons.error;
        break;
      case AlertSeverity.high:
        color = AppColors.severityHigh;
        icon = Icons.warning;
        break;
      case AlertSeverity.medium:
        color = AppColors.severityMedium;
        icon = Icons.info;
        break;
      case AlertSeverity.low:
        color = AppColors.severityLow;
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  Widget _buildProbabilityBar(
    BuildContext context,
    double probability,
    AlertSeverity severity,
  ) {
    Color color;
    switch (severity) {
      case AlertSeverity.critical:
        color = AppColors.severityCritical;
        break;
      case AlertSeverity.high:
        color = AppColors.severityHigh;
        break;
      case AlertSeverity.medium:
        color = AppColors.severityMedium;
        break;
      case AlertSeverity.low:
        color = AppColors.severityLow;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Probability',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${(probability * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: probability,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}