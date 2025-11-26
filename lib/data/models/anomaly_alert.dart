class AnomalyAlert {
  final String id;
  final DateTime timestamp;
  final AlertSeverity severity;
  final List<AlertCause> causes;
  final Map<String, dynamic> rawSensorData;
  final bool isRead;

  AnomalyAlert({
    required this.id,
    required this.timestamp,
    required this.severity,
    required this.causes,
    required this.rawSensorData,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.toString().split('.').last,
      'causes': causes.map((c) => c.toJson()).toList(),
      'rawSensorData': rawSensorData,
      'isRead': isRead,
    };
  }

  factory AnomalyAlert.fromJson(Map<String, dynamic> json) {
    return AnomalyAlert(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      severity: _parseSeverity(json['severity'] as String?),
      causes: (json['causes'] as List<dynamic>?)
              ?.map((c) => AlertCause.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      rawSensorData: json['rawSensorData'] as Map<String, dynamic>? ?? {},
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  static AlertSeverity _parseSeverity(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'low':
        return AlertSeverity.low;
      case 'medium':
        return AlertSeverity.medium;
      case 'high':
        return AlertSeverity.high;
      case 'critical':
        return AlertSeverity.critical;
      default:
        return AlertSeverity.low;
    }
  }

  AnomalyAlert copyWith({
    String? id,
    DateTime? timestamp,
    AlertSeverity? severity,
    List<AlertCause>? causes,
    Map<String, dynamic>? rawSensorData,
    bool? isRead,
  }) {
    return AnomalyAlert(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      causes: causes ?? this.causes,
      rawSensorData: rawSensorData ?? this.rawSensorData,
      isRead: isRead ?? this.isRead,
    );
  }

  AlertCause? get topCause => causes.isNotEmpty ? causes.first : null;

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

class AlertCause {
  final String name;
  final double probability;
  final String description;
  final String recommendation;

  AlertCause({
    required this.name,
    required this.probability,
    required this.description,
    required this.recommendation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'probability': probability,
      'description': description,
      'recommendation': recommendation,
    };
  }

  factory AlertCause.fromJson(Map<String, dynamic> json) {
    return AlertCause(
      name: json['name'] as String,
      probability: (json['probability'] as num).toDouble(),
      description: json['description'] as String,
      recommendation: json['recommendation'] as String,
    );
  }

  String get probabilityPercentage => '${(probability * 100).toStringAsFixed(1)}%';
}