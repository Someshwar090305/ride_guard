import 'package:ride_guard/data/models/anomaly_alert.dart';

class HealthStatus {
  final HealthLevel level;
  final String message;
  final int alertCount;
  final DateTime lastChecked;
  final List<String> issues;

  HealthStatus({
    required this.level,
    required this.message,
    required this.alertCount,
    required this.lastChecked,
    required this.issues,
  });

  // Factory constructor to calculate health from alerts
  factory HealthStatus.fromAlerts(List<AnomalyAlert> recentAlerts) {
    final now = DateTime.now();
    final last24Hours = recentAlerts.where(
      (alert) => now.difference(alert.timestamp).inHours < 24,
    ).toList();

    // Determine health level based on recent alerts
    HealthLevel level;
    String message;
    
    final criticalCount = last24Hours.where((a) => a.severity == AlertSeverity.critical).length;
    final highCount = last24Hours.where((a) => a.severity == AlertSeverity.high).length;
    final mediumCount = last24Hours.where((a) => a.severity == AlertSeverity.medium).length;

    if (criticalCount > 0) {
      level = HealthLevel.critical;
      message = 'Immediate action needed! Critical issues detected.';
    } else if (highCount > 2 || (highCount > 0 && mediumCount > 3)) {
      level = HealthLevel.critical;
      message = 'Multiple serious issues detected.';
    } else if (highCount > 0 || mediumCount > 2) {
      level = HealthLevel.warning;
      message = 'Some issues require attention.';
    } else if (mediumCount > 0 || last24Hours.length > 3) {
      level = HealthLevel.warning;
      message = 'Minor issues detected. Monitor closely.';
    } else {
      level = HealthLevel.normal;
      message = 'Everything looks good!';
    }

    // Extract unique issues
    final issues = last24Hours
        .expand((alert) => alert.causes.map((c) => c.name))
        .toSet()
        .toList();

    return HealthStatus(
      level: level,
      message: message,
      alertCount: last24Hours.length,
      lastChecked: now,
      issues: issues,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'level': level.toString().split('.').last,
      'message': message,
      'alertCount': alertCount,
      'lastChecked': lastChecked.toIso8601String(),
      'issues': issues,
    };
  }

  // Create from JSON
  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
      level: _parseHealthLevel(json['level'] as String),
      message: json['message'] as String,
      alertCount: json['alertCount'] as int,
      lastChecked: DateTime.parse(json['lastChecked'] as String),
      issues: List<String>.from(json['issues'] as List),
    );
  }

  static HealthLevel _parseHealthLevel(String level) {
    switch (level.toLowerCase()) {
      case 'normal':
        return HealthLevel.normal;
      case 'warning':
        return HealthLevel.warning;
      case 'critical':
        return HealthLevel.critical;
      default:
        return HealthLevel.normal;
    }
  }
}

enum HealthLevel {
  normal,
  warning,
  critical,
}