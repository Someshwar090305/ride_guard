class BikeProfile {
  final String id;
  final String model;
  final int yearOfPurchase;
  final DateTime? lastServiceDate;
  final double currentOdometer;
  final DateTime createdAt;

  BikeProfile({
    required this.id,
    required this.model,
    required this.yearOfPurchase,
    this.lastServiceDate,
    required this.currentOdometer,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'yearOfPurchase': yearOfPurchase,
      'lastServiceDate': lastServiceDate?.toIso8601String(),
      'currentOdometer': currentOdometer,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory BikeProfile.fromJson(Map<String, dynamic> json) {
    return BikeProfile(
      id: json['id'] as String,
      model: json['model'] as String,
      yearOfPurchase: json['yearOfPurchase'] as int,
      lastServiceDate: json['lastServiceDate'] != null
          ? DateTime.parse(json['lastServiceDate'] as String)
          : null,
      currentOdometer: (json['currentOdometer'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Copy with method for updates
  BikeProfile copyWith({
    String? id,
    String? model,
    int? yearOfPurchase,
    DateTime? lastServiceDate,
    double? currentOdometer,
    DateTime? createdAt,
  }) {
    return BikeProfile(
      id: id ?? this.id,
      model: model ?? this.model,
      yearOfPurchase: yearOfPurchase ?? this.yearOfPurchase,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Calculate days since last service
  int? daysSinceLastService() {
    if (lastServiceDate == null) return null;
    return DateTime.now().difference(lastServiceDate!).inDays;
  }

  // Check if service is due (assuming 90 days or 3000 km interval)
  bool isServiceDue({int dayInterval = 90, double kmInterval = 3000}) {
    if (lastServiceDate == null) return true;
    
    final daysSince = daysSinceLastService() ?? 0;
    return daysSince >= dayInterval;
  }
}