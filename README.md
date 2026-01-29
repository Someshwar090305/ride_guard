# RideGuard - Smart Two-Wheeler Fault Detection System

A comprehensive Flutter application for real-time health monitoring and predictive maintenance of two-wheelers (motorcycles/scooters). RideGuard continuously monitors your bike's vital parameters and alerts you to potential issues before they become critical.

## Overview

RideGuard is a sophisticated health monitoring system designed specifically for two-wheeler enthusiasts who want to maintain their vehicles in optimal condition. By analyzing sensor data and vibration patterns, the app provides:

- **Real-time Fault Detection**: Monitors multiple bike parameters continuously
- **Predictive Maintenance**: Anticipates issues before they occur
- **Intelligent Alerts**: Categorizes issues by severity with actionable recommendations
- **Service History Tracking**: Maintains detailed service logs and maintenance records
- **Health Dashboard**: Visual representation of bike health status
- **Smart Analytics**: Analyze patterns and trends in bike performance

## Features

### 🏥 Health Monitoring
- **Real-time Health Status**: Three-level health monitoring system (Normal, Warning, Critical)
- **Alert Management**: Categorize alerts by severity (Low, Medium, High, Critical)
- **Historical Data**: Track bike health over time with detailed metrics
- **Live Monitoring**: Real-time detection of abnormal patterns

### 🚨 Advanced Alert System
- **Multi-cause Analysis**: Each alert includes probable causes and their probabilities
- **Intelligent Recommendations**: Get specific repair/maintenance recommendations
- **Raw Sensor Data**: Access detailed sensor readings for each alert
- **Alert History**: Complete audit trail of all detected issues

### 🏍️ Bike Profile Management
- **Custom Bike Setup**: Register your bike with model, year, and current odometer reading
- **Service Date Tracking**: Monitor service intervals (default: 90 days or 3000 km)
- **Odometer Management**: Keep track of bike usage
- **Service Predictions**: Automatic notification when service is due

### 📊 Service Management
- **Service Logging**: Record all service activities with costs and notes
- **Service Center Tracking**: Keep records of where maintenance was performed
- **Service Interval Monitoring**: Never miss a scheduled service

### 🎨 User Experience
- **Intuitive Dashboard**: Clean, modern interface with quick stats
- **Onboarding Flow**: Guided setup for new users
- **Material Design**: Professional UI following Material 3 guidelines
- **Responsive Layout**: Optimized for various screen sizes

## Project Structure

```
ride_guard/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # App configuration and routing
│   ├── core/                              # Core utilities and constants
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Color palette definitions
│   │   │   └── app_strings.dart           # String constants
│   │   ├── theme/
│   │   │   └── app_theme.dart             # Material theme configuration
│   │   └── utils/                         # Utility functions
│   ├── data/                              # Data layer
│   │   ├── models/                        # Data models
│   │   │   ├── anomaly_alert.dart         # Alert model with severity levels
│   │   │   ├── bike_profile.dart          # Bike information model
│   │   │   ├── health_status.dart         # Computed health status model
│   │   │   └── service_log.dart           # Service history model
│   │   ├── services/                      # Data services
│   │   │   ├── storage_service.dart       # SharedPreferences wrapper
│   │   │   └── mock_data_service.dart     # Mock data generation
│   │   └── repositories/                  # Repository pattern implementations
│   └── features/                          # Feature modules
│       ├── onboarding/
│       │   ├── screens/                   # Splash, Welcome, Bike Setup screens
│       │   └── widgets/
│       ├── dashboard/
│       │   ├── screens/                   # Main dashboard screen
│       │   └── widgets/                   # Health card, stats, alerts widgets
│       ├── alerts/
│       │   ├── screens/                   # Alert details screen
│       │   └── widgets/
│       ├── history/
│       │   ├── screens/
│       │   └── widgets/
│       ├── service/
│       │   ├── screens/
│       │   └── widgets/
│       └── settings/
│           ├── screens/
│           └── widgets/
├── assets/
│   ├── images/                            # App images and illustrations
│   ├── icons/                             # App icons and SVG assets
│   └── mock_data/                         # Mock data files
├── android/                               # Android platform code
├── ios/                                   # iOS platform code
├── web/                                   # Web platform support
├── windows/                               # Windows desktop support
├── linux/                                 # Linux desktop support
├── macos/                                 # macOS desktop support
└── pubspec.yaml                           # Flutter dependencies
```

## Data Models

### AnomalyAlert
Represents a detected anomaly or issue with the bike.

```dart
class AnomalyAlert {
  String id;                          // Unique alert identifier
  DateTime timestamp;                 // When alert was detected
  AlertSeverity severity;             // low, medium, high, critical
  List<AlertCause> causes;            // Probable causes with probabilities
  Map<String, dynamic> rawSensorData; // Raw sensor readings
  bool isRead;                        // Read status
}

enum AlertSeverity { low, medium, high, critical }
```

### BikeProfile
Stores information about the user's bike.

```dart
class BikeProfile {
  String id;                  // Unique bike identifier
  String model;               // Bike model name
  int yearOfPurchase;         // Year of purchase
  DateTime? lastServiceDate;  // Last service date
  double currentOdometer;     // Current odometer reading
  DateTime createdAt;         // Profile creation date
}
```

### HealthStatus
Computed health state based on recent alerts.

```dart
class HealthStatus {
  HealthLevel level;        // normal, warning, critical
  String message;           // Human-readable status message
  int alertCount;           // Number of recent alerts
  DateTime lastChecked;     // Last health check time
  List<String> issues;      // List of detected issues
}

enum HealthLevel { normal, warning, critical }
```

### ServiceLog
Records bike service and maintenance activities.

```dart
class ServiceLog {
  String id;                  // Unique log identifier
  String serviceType;         // Type of service performed
  DateTime serviceDate;       // Date of service
  double odometerReading;     // Odometer reading at service
  double? cost;               // Service cost (optional)
  String? notes;              // Service notes
  String? serviceCenter;      // Service center name
  DateTime createdAt;         // Log creation date
}
```

## Key Components

### Core Services

#### StorageService
Manages persistent local storage using SharedPreferences.
- `saveBikeProfile()` - Save or update bike profile
- `getBikeProfile()` - Retrieve stored bike profile
- `isOnboarded()` - Check if user completed onboarding
- `clearAllData()` - Clear all stored data

#### MockDataService
Generates realistic mock sensor data and alerts for development/demo.
- `generateRandomAlert()` - Create a single random alert
- `generateHistoricalAlerts()` - Generate multiple alerts with realistic timestamps
- `generateMockSensorData()` - Create realistic sensor readings

### UI Components

#### Dashboard Screen
Main app interface showing:
- Bike health status card
- Quick statistics (total alerts, days since service)
- Recent alerts list
- Bottom navigation for feature access

#### Alert Detail Screen
Comprehensive alert information:
- Severity indicator
- Probable causes with probabilities
- Detailed recommendations
- Raw sensor data visualization

#### Health Status Card
Visual representation of bike health with color-coded status:
- Green: Normal operation
- Yellow: Warning - attention needed
- Red: Critical - immediate action required

## Dependencies

### UI & Styling
- **flutter_svg** (^2.0.10) - SVG asset support
- **google_fonts** (^6.1.0) - Custom font support
- **lottie** (^3.0.0) - Smooth animations

### State Management
- **provider** (^6.1.1) - State management and dependency injection

### Data & Storage
- **shared_preferences** (^2.2.2) - Local key-value storage
- **intl** (^0.19.0) - Internationalization and date formatting

### Utilities
- **uuid** (^4.3.3) - Unique ID generation
- **fl_chart** (^0.66.2) - Data visualization and charts

## Getting Started

### Prerequisites
- Flutter SDK 3.1.0 or higher
- Dart SDK 3.1.0 or higher
- Android SDK or Xcode for mobile development

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ride_guard.git
   cd ride_guard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate app icons** (optional)
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

For Android development:
```bash
flutter pub get
flutter run -d android
```

For iOS development:
```bash
flutter pub get
cd ios
pod install
cd ..
flutter run -d ios
```

For web development:
```bash
flutter run -d chrome
```

## App Flow

### Onboarding Flow
1. **Splash Screen** - Initial loading animation
2. **Welcome Screen** - App introduction and benefits
3. **Bike Setup Screen** - User enters bike details
4. **Dashboard** - Main app interface after setup

### Dashboard Navigation
- **Dashboard Tab** - Health status and alerts overview
- **Alerts Tab** - View and manage all alerts
- **History Tab** - Service history and past alerts
- **Service Tab** - Service log management
- **Settings Tab** - App and bike settings

## Alert Severity Levels

| Severity | Color | Description | Action |
|----------|-------|-------------|--------|
| **Low** | Blue | Minor issues, monitor closely | Schedule inspection |
| **Medium** | Yellow | Moderate issues requiring attention | Plan service soon |
| **High** | Orange | Serious issues affecting performance | Service immediately |
| **Critical** | Red | Severe issues affecting safety | Stop riding, get help |

## Alert Categories

The system can detect various issues including:
- **Engine Imbalance** - Unusual vibration patterns from engine
- **Loose Components** - Rattling or loose parts in chassis
- **Drivetrain Issues** - Chain, sprocket, or transmission problems
- **Brake System Alert** - Brake performance degradation
- **Suspension Problem** - Shock absorber or fork issues
- **Tire Pressure Low** - Incorrect tire pressure
- **Bearing Wear** - Wheel bearing degradation
- **Road Impact** - Strong impacts from road surfaces

## Customization

### Theme Colors
Modify colors in [lib/core/constants/app_colors.dart](lib/core/constants/app_colors.dart):
```dart
static const Color primaryColor = Color(0xFF...)
static const Color warningColor = Color(0xFF...)
static const Color criticalColor = Color(0xFF...)
```

### Alert Rules
Adjust alert detection logic in [lib/data/models/health_status.dart](lib/data/models/health_status.dart).

### Service Intervals
Customize service interval thresholds in [lib/data/models/bike_profile.dart](lib/data/models/bike_profile.dart):
```dart
bool isServiceDue({int dayInterval = 90, double kmInterval = 3000})
```

## Storage & Persistence

The app uses **SharedPreferences** for local storage:
- Bike profile information
- Onboarding status
- User preferences

All data is stored locally on the device. Currently, there's no cloud sync, making it a fully offline-capable application.

## Future Enhancements

- Real sensor integration (accelerometers, gyroscopes)
- Cloud backup and sync
- Multi-bike management
- Social features (compare with other riders)
- Advanced analytics and reports
- Predictive maintenance algorithms
- Service center integration
- Spare parts recommendations
- Ride statistics and analytics

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

For issues, questions, or suggestions, please open an issue on GitHub or contact the development team.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Inspired by modern vehicle health monitoring systems
- Uses open-source Flutter packages and libraries
