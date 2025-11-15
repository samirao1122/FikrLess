import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching authentication data and user state
class AuthCacheService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Save login state and user data
  static Future<void> saveLoginData({
    required String token,
    required String userId,
    String? email,
    String? phone,
    String? name,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyAuthToken, token);
    await prefs.setString(_keyUserId, userId);
    if (email != null) await prefs.setString(_keyUserEmail, email);
    if (phone != null) await prefs.setString(_keyUserPhone, phone);
    if (name != null) await prefs.setString(_keyUserName, name);
    if (role != null) await prefs.setString(_keyUserRole, role);
  }

  /// Get authentication token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Get user phone
  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  /// Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  /// Get all user data as a map
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_keyUserId),
      'email': prefs.getString(_keyUserEmail),
      'phone': prefs.getString(_keyUserPhone),
      'name': prefs.getString(_keyUserName),
      'role': prefs.getString(_keyUserRole),
      'token': prefs.getString(_keyAuthToken),
    };
  }

  /// Clear all login data (logout)
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRole);
  }

  /// Update user name
  static Future<void> updateUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Update user email
  static Future<void> updateUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }
}

