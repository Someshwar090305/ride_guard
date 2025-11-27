import 'package:flutter/material.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/data/models/bike_profile.dart';
import 'package:ride_guard/data/services/storage_service.dart';
import 'edit_bike_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  BikeProfile? _bikeProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBikeProfile();
  }

  Future<void> _loadBikeProfile() async {
    setState(() {
      _isLoading = true;
    });

    _bikeProfile = await StorageService.getBikeProfile();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _navigateToEditProfile() async {
    if (_bikeProfile == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBikeProfileScreen(bikeProfile: _bikeProfile!),
      ),
    );

    // If profile was updated, reload it
    if (result == true) {
      _loadBikeProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bike profile updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _showSwitchBikeDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Bike'),
        content: const Text(
          'Are you sure you want to switch to a different bike? Your current bike data will be removed.',
        ),
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
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/welcome',
        (route) => false,
      );
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
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        children: [
          // Bike Profile Section
          _buildSectionHeader('Bike Information'),
          
          if (_bikeProfile != null) ...[
            _buildBikeInfoCard(),
            
            _buildSettingsTile(
              icon: Icons.edit,
              title: 'Edit Bike Profile',
              subtitle: 'Update bike details',
              onTap: _navigateToEditProfile,
            ),
          ],

          const Divider(height: 32),

          // App Settings Section
          _buildSectionHeader('App Settings'),
          
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage alert notifications',
            onTap: () {
              // TODO: Implement notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),

          _buildSettingsTile(
            icon: Icons.science,
            title: 'Demo Mode',
            subtitle: 'Using mock data',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ACTIVE',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Divider(height: 32),

          // Account Section
          _buildSectionHeader('Account'),
          
          _buildSettingsTile(
            icon: Icons.swap_horiz,
            title: 'Switch Bike',
            subtitle: 'Add or switch to different bike',
            onTap: _showSwitchBikeDialog,
            textColor: AppColors.error,
          ),

          const Divider(height: 32),

          // About Section
          _buildSectionHeader('About'),
          
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About RideGuard',
            subtitle: 'Version 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.motorcycle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                children: [
                  const Text(AppStrings.appTagline),
                  const SizedBox(height: 16),
                  const Text(
                    'Smart two-wheeler health monitoring system with real-time fault detection.',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildBikeInfoCard() {
    if (_bikeProfile == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.motorcycle,
                    color: AppColors.primary,
                    size: 32,
                  ),
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
                        'Year: ${_bikeProfile!.yearOfPurchase}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.speed,
                  '${_bikeProfile!.currentOdometer.toStringAsFixed(0)} km',
                  'Odometer',
                ),
                _buildInfoItem(
                  Icons.build,
                  _bikeProfile!.lastServiceDate != null
                      ? '${_bikeProfile!.daysSinceLastService()} days ago'
                      : 'Not set',
                  'Last Service',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppColors.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}