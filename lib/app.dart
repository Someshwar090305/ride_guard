import 'package:flutter/material.dart';
import 'package:ride_guard/core/theme/app_theme.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/features/onboarding/screens/splash_screen.dart';
import 'package:ride_guard/features/onboarding/screens/welcome_screen.dart';
import 'package:ride_guard/features/onboarding/screens/bike_setup_screen.dart';
import 'package:ride_guard/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_guard/features/settings/screens/settings_screen.dart';

class RideGuardApp extends StatelessWidget {
  const RideGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
  '/': (context) => const SplashScreen(),
  '/welcome': (context) => const WelcomeScreen(),
  '/bike-setup': (context) => const BikeSetupScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/settings': (context) => const SettingsScreen(), 
},
    );
  }
}