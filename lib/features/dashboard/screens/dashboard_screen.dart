import 'package:flutter/material.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/data/models/anomaly_alert.dart';
import 'package:ride_guard/data/models/bike_profile.dart';
import 'package:ride_guard/data/models/health_status.dart';
import 'package:ride_guard/data/services/mock_data_service.dart';
import 'package:ride_guard/data/services/storage_service.dart';
import 'package:ride_guard/features/settings/screens/settings_screen.dart';
import '../widgets/health_status_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_alerts_widget.dart';
import 'package:ride_guard/features/alerts/screens/alert_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<AnomalyAlert> _alerts;
  late HealthStatus _healthStatus;
  BikeProfile? _bikeProfile;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    _bikeProfile = await StorageService.getBikeProfile();
    _loadMockData();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadMockData() {
    _alerts = MockDataService.generateHistoricalAlerts(10);
    _healthStatus = HealthStatus.fromAlerts(_alerts);
  }

  void _refreshData() {
    setState(() {
      _alerts.insert(0, MockDataService.generateRandomAlert());
      _healthStatus = HealthStatus.fromAlerts(_alerts);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New alert detected!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Bike'),
        content: const Text('Are you sure you want to switch to a different bike? Your current data will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Switch Bike'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await StorageService.clearAllData();
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.dashboard),
            if (_bikeProfile != null)
              Text(
                _bikeProfile!.model,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Generate Alert (Demo)',
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: _logout,
            tooltip: 'Switch Bike',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Reload data when returning to dashboard
          if (index == 0) {
            _loadData();
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildAlertsTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return const SettingsScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike Info Card
            if (_bikeProfile != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.motorcycle,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bikeProfile!.model,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Year: ${_bikeProfile!.yearOfPurchase} • ${_bikeProfile!.currentOdometer.toStringAsFixed(0)} km',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Health Status Card
            HealthStatusCard(healthStatus: _healthStatus),
            const SizedBox(height: 16),
            
            // Quick Stats
            QuickStatsCard(
              totalAlerts: _alerts.length,
              todayAlerts: _alerts.where((a) => 
                DateTime.now().difference(a.timestamp).inHours < 24
              ).length,
              daysSinceService: _bikeProfile?.daysSinceLastService() ?? 0,
            ),
            const SizedBox(height: 24),
            
            // Recent Alerts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.recentAlerts,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: const Text(AppStrings.viewAll),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            RecentAlertsWidget(alerts: _alerts.take(5).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_active,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Live Monitoring',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: _getSeverityIcon(alert.severity),
            title: Text(
              alert.topCause?.name ?? 'Unknown Issue',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(alert.timeAgo),
            trailing: Text(
              alert.topCause?.probabilityPercentage ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlertDetailScreen(alert: alert),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _getSeverityIcon(AlertSeverity severity) {
    IconData icon;
    Color color;
    
    switch (severity) {
      case AlertSeverity.critical:
        icon = Icons.error;
        color = AppColors.severityCritical;
        break;
      case AlertSeverity.high:
        icon = Icons.warning;
        color = AppColors.severityHigh;
        break;
      case AlertSeverity.medium:
        icon = Icons.info;
        color = AppColors.severityMedium;
        break;
      case AlertSeverity.low:
        icon = Icons.check_circle;
        color = AppColors.severityLow;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}