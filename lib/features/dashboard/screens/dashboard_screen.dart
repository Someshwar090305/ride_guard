import 'package:flutter/material.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/data/models/anomaly_alert.dart';
import 'package:ride_guard/data/models/health_status.dart';
import 'package:ride_guard/data/services/mock_data_service.dart';
import '../widgets/health_status_card.dart';
import '../widgets/quick_stats_card.dart';
import '../widgets/recent_alerts_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<AnomalyAlert> _alerts;
  late HealthStatus _healthStatus;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Generate some mock alerts for demo
    _alerts = MockDataService.generateHistoricalAlerts(10);
    _healthStatus = HealthStatus.fromAlerts(_alerts);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dashboard),
        actions: [
          // Demo: Manual refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Generate Alert (Demo)',
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
            icon: Icon(Icons.build),
            label: 'Service',
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
        return _buildServiceTab();
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
            // Health Status Card
            HealthStatusCard(healthStatus: _healthStatus),
            const SizedBox(height: 16),
            
            // Quick Stats
            QuickStatsCard(
              totalAlerts: _alerts.length,
              todayAlerts: _alerts.where((a) => 
                DateTime.now().difference(a.timestamp).inHours < 24
              ).length,
              daysSinceService: 45,
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
          ),
        );
      },
    );
  }

  Widget _buildServiceTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.build_circle,
            size: 80,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Service Log',
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