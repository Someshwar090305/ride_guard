class ServiceLog {
  final String id;
  final String serviceType;
  final DateTime serviceDate;
  final double odometerReading;
  final double? cost;
  final String? notes;
  final String? serviceCenter;
  final DateTime createdAt;

  ServiceLog({
    required this.id,
    required this.serviceType,
    required this.serviceDate,
    required this.odometerReading,
    this.cost,
    this.notes,
    this.serviceCenter,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'serviceDate': serviceDate.toIso8601String(),
      'odometerReading': odometerReading,
      'cost': cost,
      'notes': notes,
      'serviceCenter': serviceCenter,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory ServiceLog.fromJson(Map<String, dynamic> json) {
    return ServiceLog(
      id: json['id'] as String,
      serviceType: json['serviceType'] as String,
      serviceDate: DateTime.parse(json['serviceDate'] as String),
      odometerReading: (json['odometerReading'] as num).toDouble(),
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      notes: json['notes'] as String?,
      serviceCenter: json['serviceCenter'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Copy with method
  ServiceLog copyWith({
    String? id,
    String? serviceType,
    DateTime? serviceDate,
    double? odometerReading,
    double? cost,
    String? notes,
    String? serviceCenter,
    DateTime? createdAt,
  }) {
    return ServiceLog(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      serviceDate: serviceDate ?? this.serviceDate,
      odometerReading: odometerReading ?? this.odometerReading,
      cost: cost ?? this.cost,
      notes: notes ?? this.notes,
      serviceCenter: serviceCenter ?? this.serviceCenter,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Get days since service
  int get daysSinceService {
    return DateTime.now().difference(serviceDate).inDays;
  }

  // Common service types
  static const String oilChange = 'Oil Change';
  static const String generalService = 'General Service';
  static const String brakeService = 'Brake Service';
  static const String chainLubrication = 'Chain Lubrication';
  static const String tireReplacement = 'Tire Replacement';
  static const String sparkPlugReplacement = 'Spark Plug Replacement';
  static const String airFilterReplacement = 'Air Filter Replacement';
  static const String coolantRefill = 'Coolant Refill';
  static const String batteryReplacement = 'Battery Replacement';
  static const String other = 'Other';

  static List<String> get serviceTypes => [
        generalService,
        oilChange,
        brakeService,
        chainLubrication,
        tireReplacement,
        sparkPlugReplacement,
        airFilterReplacement,
        coolantRefill,
        batteryReplacement,
        other,
      ];
}