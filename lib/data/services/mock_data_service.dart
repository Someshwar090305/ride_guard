import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:ride_guard/data/models/anomaly_alert.dart';
import 'package:ride_guard/data/models/service_log.dart';

class MockDataService {
  static final Random _random = Random();
  static const Uuid _uuid = Uuid();

  // Sample alert causes with descriptions and recommendations
  static final List<Map<String, dynamic>> _alertCauses = [
    {
      'name': 'Engine Imbalance',
      'description': 'Unusual vibration patterns detected from the engine',
      'recommendation': 'Schedule engine inspection. Check spark plugs and fuel injectors.',
    },
    {
      'name': 'Loose Components',
      'description': 'Rattling or loose parts detected in the chassis',
      'recommendation': 'Tighten all bolts and check for loose parts, especially exhaust mounts.',
    },
    {
      'name': 'Drivetrain Issues',
      'description': 'Abnormal vibration in chain or transmission system',
      'recommendation': 'Inspect chain tension and sprocket wear. Lubricate if needed.',
    },
    {
      'name': 'Brake System Alert',
      'description': 'Unusual brake system behavior detected',
      'recommendation': 'Check brake pads and fluid levels immediately.',
    },
    {
      'name': 'Suspension Problem',
      'description': 'Abnormal suspension movement pattern',
      'recommendation': 'Inspect shock absorbers and fork oil levels.',
    },
    {
      'name': 'Tire Pressure Low',
      'description': 'Handling characteristics suggest low tire pressure',
      'recommendation': 'Check and adjust tire pressure to manufacturer specifications.',
    },
    {
      'name': 'Road Bump Impact',
      'description': 'Strong impact detected from road surface',
      'recommendation': 'Inspect for potential damage from road hazard.',
    },
    {
      'name': 'Bearing Wear',
      'description': 'Wheel bearing showing signs of wear',
      'recommendation': 'Service wheel bearings or replace if necessary.',
    },
  ];

  // Generate a random alert
  static AnomalyAlert generateRandomAlert() {
    final severity = _randomSeverity();
    final numCauses = _random.nextInt(2) + 2; // 2-3 causes
    final selectedCauses = _selectRandomCauses(numCauses);

    return AnomalyAlert(
      id: _uuid.v4(),
      timestamp: DateTime.now().subtract(
        Duration(
          minutes: _random.nextInt(60),
          seconds: _random.nextInt(60),
        ),
      ),
      severity: severity,
      causes: selectedCauses,
      rawSensorData: _generateMockSensorData(),
      isRead: false,
    );
  }

  // Generate historical alerts
  static List<AnomalyAlert> generateHistoricalAlerts(int count) {
    final alerts = <AnomalyAlert>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final daysAgo = _random.nextInt(30);
      final hoursAgo = _random.nextInt(24);
      final minutesAgo = _random.nextInt(60);

      final severity = _randomSeverity();
      final numCauses = _random.nextInt(2) + 2;
      final selectedCauses = _selectRandomCauses(numCauses);

      alerts.add(
        AnomalyAlert(
          id: _uuid.v4(),
          timestamp: now.subtract(
            Duration(
              days: daysAgo,
              hours: hoursAgo,
              minutes: minutesAgo,
            ),
          ),
          severity: severity,
          causes: selectedCauses,
          rawSensorData: _generateMockSensorData(),
          isRead: _random.nextBool(),
        ),
      );
    }

    // Sort by timestamp (newest first)
    alerts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return alerts;
  }

  // Generate sample service logs
  static List<ServiceLog> generateSampleServiceLogs() {
    final now = DateTime.now();
    return [
      ServiceLog(
        id: _uuid.v4(),
        serviceType: ServiceLog.generalService,
        serviceDate: now.subtract(const Duration(days: 45)),
        odometerReading: 8500,
        cost: 2500,
        notes: 'Regular maintenance - oil change, chain lubrication',
        serviceCenter: 'City Service Center',
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      ServiceLog(
        id: _uuid.v4(),
        serviceType: ServiceLog.oilChange,
        serviceDate: now.subtract(const Duration(days: 90)),
        odometerReading: 7200,
        cost: 800,
        notes: 'Engine oil and filter replacement',
        serviceCenter: 'Quick Service Hub',
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      ServiceLog(
        id: _uuid.v4(),
        serviceType: ServiceLog.chainLubrication,
        serviceDate: now.subtract(const Duration(days: 15)),
        odometerReading: 8800,
        cost: 150,
        notes: 'Chain cleaning and lubrication',
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }

  // Private helper methods
  static AlertSeverity _randomSeverity() {
    final rand = _random.nextInt(100);
    if (rand < 5) return AlertSeverity.critical; // 5%
    if (rand < 20) return AlertSeverity.high; // 15%
    if (rand < 50) return AlertSeverity.medium; // 30%
    return AlertSeverity.low; // 50%
  }

  static List<AlertCause> _selectRandomCauses(int count) {
    final shuffled = List.from(_alertCauses)..shuffle(_random);
    final selected = shuffled.take(count).toList();

    // Generate probabilities that sum to ~1.0
    final probabilities = _generateProbabilities(count);

    return List.generate(
      count,
      (index) {
        final cause = selected[index];
        return AlertCause(
          name: cause['name'] as String,
          probability: probabilities[index],
          description: cause['description'] as String,
          recommendation: cause['recommendation'] as String,
        );
      },
    );
  }

  static List<double> _generateProbabilities(int count) {
    final probs = List.generate(count, (_) => _random.nextDouble());
    final sum = probs.reduce((a, b) => a + b);
    final normalized = probs.map((p) => p / sum).toList();
    
    // Sort descending
    normalized.sort((a, b) => b.compareTo(a));
    return normalized;
  }

  static Map<String, dynamic> _generateMockSensorData() {
    return {
      'accelerometer': {
        'x': (_random.nextDouble() * 20 - 10).toStringAsFixed(3),
        'y': (_random.nextDouble() * 20 - 10).toStringAsFixed(3),
        'z': (_random.nextDouble() * 20 - 10).toStringAsFixed(3),
      },
      'gyroscope': {
        'x': (_random.nextDouble() * 500 - 250).toStringAsFixed(3),
        'y': (_random.nextDouble() * 500 - 250).toStringAsFixed(3),
        'z': (_random.nextDouble() * 500 - 250).toStringAsFixed(3),
      },
      'temperature': (20 + _random.nextDouble() * 30).toStringAsFixed(1),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Stream that generates alerts periodically (for demo)
  static Stream<AnomalyAlert> alertStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 15 + _random.nextInt(30)));
      // 30% chance to generate an alert
      if (_random.nextInt(100) < 30) {
        yield generateRandomAlert();
      }
    }
  }
}