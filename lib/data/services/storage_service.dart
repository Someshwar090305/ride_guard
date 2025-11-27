import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ride_guard/data/models/bike_profile.dart';

class StorageService {
  static const String _bikeProfileKey = 'bike_profile';
  static const String _isOnboardedKey = 'is_onboarded';

  // Save bike profile
  static Future<bool> saveBikeProfile(BikeProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(profile.toJson());
      await prefs.setString(_bikeProfileKey, jsonString);
      await prefs.setBool(_isOnboardedKey, true);
      return true;
    } catch (e) {
      print('Error saving bike profile: $e');
      return false;
    }
  }

  // Get bike profile
  static Future<BikeProfile?> getBikeProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_bikeProfileKey);
      
      if (jsonString == null) return null;
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return BikeProfile.fromJson(jsonMap);
    } catch (e) {
      print('Error loading bike profile: $e');
      return null;
    }
  }

  // Check if user has completed onboarding
  static Future<bool> isOnboarded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isOnboardedKey) ?? false;
    } catch (e) {
      print('Error checking onboarding status: $e');
      return false;
    }
  }

  // Clear all data (logout)
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bikeProfileKey);
      await prefs.remove(_isOnboardedKey);
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  // Update bike profile
  static Future<bool> updateBikeProfile(BikeProfile profile) async {
    return await saveBikeProfile(profile);
  }
}