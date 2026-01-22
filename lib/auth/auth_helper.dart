import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userTypeKey = 'user_type';
  static const String _phoneNumberKey = 'phone_number';

  // User types
  static const String userTypeNormal = 'normal';
  static const String userTypeAdmin = 'admin';

  // Save login data
  static Future<void> saveLoginData({
    required String phoneNumber,
    required String userType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userTypeKey, userType);
    await prefs.setString(_phoneNumberKey, phoneNumber);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get user type
  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  // Get phone number
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  // Logout - clear all data
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check login status and get user type in one call
  static Future<Map<String, dynamic>> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isLoggedIn': prefs.getBool(_isLoggedInKey) ?? false,
      'userType': prefs.getString(_userTypeKey),
      'phoneNumber': prefs.getString(_phoneNumberKey),
    };
  }
}