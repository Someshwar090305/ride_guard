import 'package:flutter/material.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/data/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
    
    // Check onboarding status and navigate accordingly
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    // Check if user has completed onboarding
    final isOnboarded = await StorageService.isOnboarded();
    
    if (isOnboarded) {
      // User has already set up bike, go to dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      // New user, show welcome screen
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.motorcycle,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 30),
                
                // App Name
                Text(
                  AppStrings.appName,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Tagline
                Text(
                  AppStrings.appTagline,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}