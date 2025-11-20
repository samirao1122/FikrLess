import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';

// Updated base URL
const String baseUrl = 'https://fikrless.com/api/v1';

/// Base API service for handling HTTP requests
class ApiService {
  /// Get headers for API requests
  static Map<String, String> getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Log API request
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    print('═══════════════════════════════════════════════════════════');
    print('📤 API REQUEST');
    print('Method: $method');
    print('URL: $url');
    
    if (headers != null) {
      // Mask token in headers for security
      final safeHeaders = Map<String, String>.from(headers);
      if (safeHeaders.containsKey('Authorization')) {
        final authHeader = safeHeaders['Authorization']!;
        if (authHeader.startsWith('Bearer ')) {
          final token = authHeader.substring(7);
          final maskedToken = token.length > 10 
              ? '${token.substring(0, 10)}...${token.substring(token.length - 4)}'
              : '***';
          safeHeaders['Authorization'] = 'Bearer $maskedToken';
        }
      }
      print('Headers: ${json.encode(safeHeaders)}');
    }
    
    if (body != null) {
      try {
        final bodyStr = body is String ? body : json.encode(body);
        // Truncate very long bodies
        final displayBody = bodyStr.length > 500 
            ? '${bodyStr.substring(0, 500)}... (truncated)'
            : bodyStr;
        print('Body: $displayBody');
      } catch (e) {
        print('Body: [Unable to encode body]');
      }
    }
    
    print('═══════════════════════════════════════════════════════════');
  }

  /// Log API response
  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    String? body,
  }) {
    print('═══════════════════════════════════════════════════════════');
    print('📥 API RESPONSE');
    print('Method: $method');
    print('URL: $url');
    print('Status Code: $statusCode ${statusCode >= 200 && statusCode < 300 ? '✅' : '❌'}');
    
    if (body != null) {
      try {
        // Truncate very long bodies
        final displayBody = body.length > 500 
            ? '${body.substring(0, 500)}... (truncated)'
            : body;
        print('Body: $displayBody');
      } catch (e) {
        print('Body: [Unable to display body]');
      }
    }
    
    print('═══════════════════════════════════════════════════════════');
  }

  /// Handle API errors
  static String handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error: ${error.message}';
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else {
      return 'An error occurred: ${error.toString()}';
    }
  }

  /// Wrapper for http.get with automatic logging
  static Future<http.Response> loggedGet(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    logRequest(method: 'GET', url: url.toString(), headers: headers);
    final response = await http.get(url, headers: headers);
    logResponse(
      method: 'GET',
      url: url.toString(),
      statusCode: response.statusCode,
      body: response.body,
    );
    return response;
  }

  /// Wrapper for http.post with automatic logging
  static Future<http.Response> loggedPost(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    logRequest(method: 'POST', url: url.toString(), headers: headers, body: body);
    final response = await http.post(url, headers: headers, body: body);
    logResponse(
      method: 'POST',
      url: url.toString(),
      statusCode: response.statusCode,
      body: response.body,
    );
    return response;
  }

  /// Wrapper for http.put with automatic logging
  static Future<http.Response> loggedPut(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    logRequest(method: 'PUT', url: url.toString(), headers: headers, body: body);
    final response = await http.put(url, headers: headers, body: body);
    logResponse(
      method: 'PUT',
      url: url.toString(),
      statusCode: response.statusCode,
      body: response.body,
    );
    return response;
  }

  /// Wrapper for http.delete with automatic logging
  static Future<http.Response> loggedDelete(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    logRequest(method: 'DELETE', url: url.toString(), headers: headers);
    final response = await http.delete(url, headers: headers);
    logResponse(
      method: 'DELETE',
      url: url.toString(),
      statusCode: response.statusCode,
      body: response.body,
    );
    return response;
  }
}

/// Service for Auth API calls
class AuthApiService extends ApiService {
  /// Signup - Registers a new user
  static Future<Map<String, dynamic>?> signup({
    required String email,
    required String password,
    required String userType, // 'user', 'specialist', or 'admin'
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: ApiService.getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
          'user_type': userType,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Signup failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during signup: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Login - Authenticates user
  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: ApiService.getHeaders(),
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Email Verify - Verifies OTP sent during signup
  static Future<Map<String, dynamic>?> emailVerify({
    required String token, // OTP token
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/email-verify'),
        headers: ApiService.getHeaders(),
        body: json.encode({
          'token': token,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Email verify failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during email verify: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Forgot Password - Triggers password reset flow
  static Future<bool> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: ApiService.getHeaders(),
        body: json.encode({
          'email': email,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error during forgot password: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Change Password - Sets new password for authenticated user
  static Future<bool> changePassword({
    required String token, // JWT token
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/change-password'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'new_password': newPassword,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error changing password: ${ApiService.handleError(e)}');
      return false;
    }
  }
}

/// Service for Demographics API calls
class DemographicsApiService extends ApiService {
  /// Save Demographics - Stores onboarding information
  static Future<bool> saveDemographics({
    required String userId,
    required Map<String, dynamic> demographics,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/demographics'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'user_id': userId,
          'demographics': demographics,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error saving demographics: ${ApiService.handleError(e)}');
      return false;
    }
  }
}

/// Service for mood-related API calls
class MoodApiService extends ApiService {
  /// Save/Update Today's Mood
  static Future<Map<String, dynamic>?> saveMood({
    required String mood,
    String? journalEntry,
    String? date, // Optional: for specific date
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'mood': mood,
      };
      if (journalEntry != null && journalEntry.isNotEmpty) {
        body['journal_entry'] = journalEntry;
      }
      if (date != null && date.isNotEmpty) {
        body['date'] = date;
      }

      // Debug logging
      print('=== MOOD API REQUEST ===');
      print('Token: $token');
      print('URL: $baseUrl/mood');
      print('Request Body: ${json.encode(body)}');
      print('=======================');

      final response = await http.post(
        Uri.parse('$baseUrl/mood'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      // Debug logging
      print('=== MOOD API RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('========================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedResponse = json.decode(response.body);
        print('Decoded Response: $decodedResponse');
        return decodedResponse;
      } else {
        print('Error: Status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error saving mood: ${ApiService.handleError(e)}');
      print('Exception details: $e');
      return null;
    }
  }

  /// Get Today's Mood
  /// Response: { "success": true, "data": { "mood": "...", ... } }
  static Future<Map<String, dynamic>?> getCurrentMood({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mood'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Extract data from response: { "success": true, "data": {...} }
        if (result['success'] == true && result['data'] != null) {
          return result['data'] as Map<String, dynamic>;
        }
        return result;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mood: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Mood for Specific Date
  /// Response: { "success": true, "data": { "mood": "...", ... } }
  static Future<Map<String, dynamic>?> getMoodForDate({
    required String date, // YYYY-MM-DD format
    String? token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mood?date=$date'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Extract data from response: { "success": true, "data": {...} }
        if (result['success'] == true && result['data'] != null) {
          return result['data'] as Map<String, dynamic>;
        }
        return result;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mood for date: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Mood History (paginated)
  /// Response: { "success": true, "data": { "moods": [...], "pagination": {...} } }
  static Future<Map<String, dynamic>?> getMoodHistory({
    required String token,
    int limit = 10,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mood/history?limit=$limit&page=$page'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        // Return the full response structure with data.moods and data.pagination
        return result;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mood history: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Update Mood Entry
  static Future<bool> updateMood({
    required String id,
    required String mood,
    String? journalEntry,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'mood': mood,
      };
      if (journalEntry != null && journalEntry.isNotEmpty) {
        body['journal_entry'] = journalEntry;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/mood/$id'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating mood: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Delete Mood Entry
  static Future<bool> deleteMood({
    required String id,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/mood/$id'),
        headers: ApiService.getHeaders(token: token),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting mood: ${ApiService.handleError(e)}');
      return false;
    }
  }

  // Legacy methods for backward compatibility
  /// Submit mood to API (legacy - uses saveMood)
  static Future<bool> submitMood({
    required String mood,
    String? notes,
    String? token,
  }) async {
    final result = await saveMood(
      mood: mood,
      journalEntry: notes,
      token: token ?? '',
    );
    return result != null;
  }

  /// Update mood (legacy - uses saveMood with date)
  static Future<bool> updateMoodLegacy({
    required String mood,
    required String modeDesc,
    required String date,
    required String token,
  }) async {
    final result = await saveMood(
      mood: mood,
      journalEntry: modeDesc,
      date: date,
      token: token,
    );
    return result != null;
  }
}

/// Service for step tracking API calls
class StepsApiService extends ApiService {
  /// Batch Sync Steps - Preferred mobile sync endpoint
  static Future<bool> batchSyncSteps({
    required List<Map<String, dynamic>> entries,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/activity/steps/sync');
      final headers = ApiService.getHeaders(token: token);
      final body = json.encode({
        'entries': entries,
      });
      
      final response = await ApiService.loggedPost(
        url,
        headers: headers,
        body: body,
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Error syncing steps batch: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Create Single Steps Entry
  static Future<Map<String, dynamic>?> createStepsEntry({
    required int steps,
    required String date, // YYYY-MM-DD
    int? caloriesBurned,
    double? distanceKm,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'steps': steps,
        'date': date,
      };
      if (caloriesBurned != null) body['calories_burned'] = caloriesBurned;
      if (distanceKm != null) body['distance_km'] = distanceKm;

      final response = await http.post(
        Uri.parse('$baseUrl/activity/steps'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error creating steps entry: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Steps (Today)
  static Future<Map<String, dynamic>?> getTodaySteps({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/steps'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching today steps: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Steps (Specific Date)
  static Future<Map<String, dynamic>?> getStepsForDate({
    required String date, // YYYY-MM-DD
    String? token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/steps?date=$date'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching steps for date: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Steps History (Daily)
  static Future<Map<String, dynamic>?> getStepsHistory({
    required String token,
    String period = 'daily', // daily, weekly, monthly
    int limit = 30,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/steps/history?period=$period&limit=$limit&page=$page'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching steps history: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Update Steps Entry
  static Future<bool> updateSteps({
    required String id,
    required int steps,
    int? caloriesBurned,
    double? distanceKm,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'steps': steps,
      };
      if (caloriesBurned != null) body['calories_burned'] = caloriesBurned;
      if (distanceKm != null) body['distance_km'] = distanceKm;

      final response = await http.put(
        Uri.parse('$baseUrl/activity/steps/$id'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating steps: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Delete Steps Entry
  static Future<bool> deleteSteps({
    required String id,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/activity/steps/$id'),
        headers: ApiService.getHeaders(token: token),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting steps: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Get Steps Statistics
  static Future<Map<String, dynamic>?> getStepsStats({
    required String token,
    int period = 30, // Number of days
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/steps/stats?period=$period'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching steps stats: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Current Streak
  static Future<Map<String, dynamic>?> getCurrentStreak({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/activity/steps/current-streak'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching current streak: ${ApiService.handleError(e)}');
      return null;
    }
  }

  // Legacy method for backward compatibility
  /// Sync steps to API (legacy - uses createStepsEntry)
  static Future<bool> syncSteps({
    required String steps,
    required String time,
    required String token,
  }) async {
    try {
      final stepsInt = int.tryParse(steps) ?? 0;
      final date = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
      
      final result = await createStepsEntry(
        steps: stepsInt,
        date: date,
        token: token,
      );
      return result != null;
    } catch (e) {
      print('Error syncing steps: ${ApiService.handleError(e)}');
      return false;
    }
  }
}

/// Service for Notifications API calls
class NotificationsApiService extends ApiService {
  /// List Notifications
  static Future<Map<String, dynamic>?> getNotifications({
    required String token,
    String status = 'all', // all, unread, read
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications?status=$status&page=$page&limit=$limit'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching notifications: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Notification Detail
  static Future<Map<String, dynamic>?> getNotificationDetail({
    required String notificationId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/$notificationId'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching notification detail: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Update Notification Status
  static Future<bool> updateNotificationStatus({
    required String notificationId,
    required String status, // read, unread, archived
    required String token,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'status': status,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating notification status: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Mark All Read
  static Future<bool> markAllRead({required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/mark-all-read'),
        headers: ApiService.getHeaders(token: token),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error marking all as read: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Delete Notification
  static Future<bool> deleteNotification({
    required String notificationId,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notifications/$notificationId'),
        headers: ApiService.getHeaders(token: token),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting notification: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Clear All Notifications
  static Future<bool> clearAllNotifications({required String token}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notifications'),
        headers: ApiService.getHeaders(token: token),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error clearing all notifications: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Get Unread Count
  static Future<int?> getUnreadCount({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/unread-count'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle both response formats: { "count": 5 } or { "success": true, "data": { "count": 5 } }
        if (data['success'] == true && data['data'] != null) {
          return data['data']['count'] as int?;
        } else if (data['count'] != null) {
          return data['count'] as int?;
        }
        return 0;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching unread count: ${ApiService.handleError(e)}');
      return null;
    }
  }

  // Legacy methods for backward compatibility
  /// Get notifications with filters (legacy)
  static Future<List<Map<String, dynamic>>?> getNotificationsLegacy({
    required String token,
    int limit = 10,
    int offset = 1,
    String? date,
    String? id,
    String? type,
  }) async {
    final result = await getNotifications(
      token: token,
      page: offset,
      limit: limit,
    );
    if (result != null && result['data'] != null) {
      return (result['data'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Mark notifications as read (legacy)
  static Future<bool> markAsRead({
    required String token,
    required List<String> ids,
  }) async {
    // Mark each notification individually
    bool allSuccess = true;
    for (final id in ids) {
      final success = await updateNotificationStatus(
        notificationId: id,
        status: 'read',
        token: token,
      );
      if (!success) allSuccess = false;
    }
    return allSuccess;
  }

  /// Delete notifications (legacy)
  static Future<bool> deleteNotifications({
    required String token,
    required List<String> ids,
  }) async {
    // Delete each notification individually
    bool allSuccess = true;
    for (final id in ids) {
      final success = await deleteNotification(
        notificationId: id,
        token: token,
      );
      if (!success) allSuccess = false;
    }
    return allSuccess;
  }
}

/// Service for Specialist API calls
class SpecialistApiService extends ApiService {
  /// Create Specialist Profile
  static Future<Map<String, dynamic>?> createSpecialistProfile({
    required Map<String, dynamic> basicInfo,
    List<Map<String, dynamic>>? education,
    List<Map<String, dynamic>>? certifications,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'basic_info': basicInfo,
      };
      if (education != null) body['education'] = education;
      if (certifications != null) body['certifications'] = certifications;

      final response = await http.post(
        Uri.parse('$baseUrl/specialist/profile'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Create specialist profile failed: ${response.statusCode} - ${response.body}');
        return {'error': response.body, 'statusCode': response.statusCode};
      }
    } catch (e) {
      print('Error creating specialist profile: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Specialist Profile
  /// Returns: { "success": true, "data": { ... } } or null
  static Future<Map<String, dynamic>?> getSpecialistProfile({required String token}) async {
    try {
      final response = await ApiService.loggedGet(
        Uri.parse('$baseUrl/specialist/profile'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Return the full response (includes success and data)
        return decoded;
      } else {
        print('Get specialist profile failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching specialist profile: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Update Specialist Profile
  /// Request format: { "basic_info": {...}, "education": [...], "certifications": [...] }
  static Future<bool> updateSpecialistProfile({
    required Map<String, dynamic> basicInfo,
    List<Map<String, dynamic>>? education,
    List<Map<String, dynamic>>? certifications,
    required String token,
  }) async {
    try {
      final body = <String, dynamic>{
        'basic_info': basicInfo,
      };
      
      // Only include education if provided and not empty
      if (education != null && education.isNotEmpty) {
        body['education'] = education;
      }
      
      // Only include certifications if provided and not empty
      if (certifications != null && certifications.isNotEmpty) {
        body['certifications'] = certifications;
      }

      // Log request for debugging
      ApiService.logRequest(
        method: 'PUT',
        url: '$baseUrl/specialist/profile',
        headers: ApiService.getHeaders(token: token),
        body: body,
      );

      final response = await ApiService.loggedPut(
        Uri.parse('$baseUrl/specialist/profile'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('❌ Update profile failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating specialist profile: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Get All Specialists (public listing)
  static Future<Map<String, dynamic>?> getAllSpecialists({
    bool? verified,
    String? location,
    String? specialization,
    String? category,
    String? search,
    double? minRating,
    int? minExperience,
    int page = 1,
    int limit = 10,
    String? token,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (verified != null) queryParams['verified'] = verified.toString();
      if (location != null) queryParams['location'] = location;
      if (specialization != null) queryParams['specialization'] = specialization;
      if (category != null) queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (minRating != null) queryParams['min_rating'] = minRating.toString();
      if (minExperience != null) queryParams['min_experience'] = minExperience.toString();
      queryParams['page'] = page.toString();
      queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$baseUrl/specialist/specialists').replace(queryParameters: queryParams);
      final headers = ApiService.getHeaders(token: token);
      
      final response = await ApiService.loggedGet(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching specialists: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Specialist Highlights
  static Future<List<Map<String, dynamic>>?> getSpecialistHighlights({
    String? location,
    int limit = 3,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (location != null) queryParams['location'] = location;

      final uri = Uri.parse('$baseUrl/specialist/highlights').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching specialist highlights: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Specialist Suggestions
  static Future<List<String>?> getSpecialistSuggestions({required String term}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/specialist/suggestions?term=$term'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<String>();
        } else if (data is Map && data['suggestions'] != null) {
          return (data['suggestions'] as List).cast<String>();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching specialist suggestions: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get Specialist Public Profile
  static Future<Map<String, dynamic>?> getSpecialistPublicProfile({required String specialistId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/specialist/profiles/$specialistId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching specialist public profile: ${ApiService.handleError(e)}');
      return null;
    }
  }
}

/// Service for Spiritual Hub API calls
class SpiritualHubApiService extends ApiService {
  /// Get Mindfulness Practitioners
  static Future<Map<String, dynamic>?> getMindfulnessPractitioners({
    String? category,
    String? location,
    double? minRating,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;
      if (minRating != null) queryParams['min_rating'] = minRating.toString();

      final uri = Uri.parse('$baseUrl/spiritual/practitioners').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mindfulness practitioners: ${ApiService.handleError(e)}');
      return null;
    }
  }

  // Legacy methods for backward compatibility
  /// Get slider reminder images (legacy - may need to be updated)
  static Future<List<Map<String, dynamic>>?> getSliderImages({String? token}) async {
    try {
      // Note: This endpoint may not exist in new API, keeping for backward compatibility
      final response = await http.get(
        Uri.parse('$baseUrl/slider_img_remider'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching slider images: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get guided meditation audios (legacy - may need to be updated)
  static Future<List<Map<String, dynamic>>?> getGuidedMeditationAudios({String? token}) async {
    try {
      // Note: This endpoint may not exist in new API, keeping for backward compatibility
      final response = await http.get(
        Uri.parse('$baseUrl/guided_meditation_audio'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching meditation audios: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get categories for practitioners (legacy)
  static Future<List<Map<String, dynamic>>?> getCategories({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_categories'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching categories: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Get practitioners with pagination (legacy)
  static Future<Map<String, dynamic>?> getPractitioners({
    required int limit,
    required int offset,
    required String category,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_practioners'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'limit': limit,
          'offset': offset,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['data'] != null) {
          return {
            'data': (data['data'] as List).cast<Map<String, dynamic>>(),
            'hasMore': (data['data'] as List).length == limit,
          };
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching practitioners: ${ApiService.handleError(e)}');
      return null;
    }
  }
}

/// Service for quote of the day API calls
class QuoteApiService extends ApiService {
  /// Get quote of the day from API
  static Future<Map<String, dynamic>?> getQuoteOfTheDay({String? token}) async {
    try {
      // Note: This endpoint may not exist in new API, keeping for backward compatibility
      final response = await http.get(
        Uri.parse('$baseUrl/quotes/daily'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching quote: ${ApiService.handleError(e)}');
      return null;
    }
  }
}

/// Service for Achievements API calls
class AchievementsApiService extends ApiService {
  /// Get recent achievements
  static Future<List<Map<String, dynamic>>?> getRecentAchievements({
    required String token,
    int limit = 5,
  }) async {
    try {
      // TODO: Replace with actual API call when ready
      await Future.delayed(Duration(milliseconds: 500));
      return _getDummyRecentAchievements();
    } catch (e) {
      print('Error fetching recent achievements: ${ApiService.handleError(e)}');
      return _getDummyRecentAchievements();
    }
  }

  /// Get all achievements
  static Future<Map<String, dynamic>?> getAllAchievements({
    required String token,
  }) async {
    try {
      // TODO: Replace with actual API call when ready
      await Future.delayed(Duration(milliseconds: 500));
      return _getDummyAllAchievements();
    } catch (e) {
      print('Error fetching achievements: ${ApiService.handleError(e)}');
      return _getDummyAllAchievements();
    }
  }

  static List<Map<String, dynamic>> _getDummyRecentAchievements() {
    return [
      {
        'id': '1',
        'title': 'Week Warrior',
        'description': '7 days in a row',
        'icon': 'week_warrior',
        'unlocked': true,
        'unlockedDate': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
      },
      {
        'id': '2',
        'title': 'Community Helper',
        'description': 'Helped 5 people in forums',
        'icon': 'community_helper',
        'unlocked': true,
        'unlockedDate': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
      },
    ];
  }

  static Map<String, dynamic> _getDummyAllAchievements() {
    return {
      'total': 10,
      'unlocked': 4,
      'achievements': [
        {
          'id': '1',
          'title': 'Week Warrior',
          'description': '7 days in a row',
          'icon': 'week_warrior',
          'unlocked': true,
          'unlockedDate': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        },
        {
          'id': '2',
          'title': 'Community Helper',
          'description': 'Helped 5 people in forums',
          'icon': 'community_helper',
          'unlocked': true,
          'unlockedDate': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        },
        {
          'id': '3',
          'title': 'Community Helper',
          'description': 'Helped 5 people in forums',
          'icon': 'community_helper',
          'unlocked': true,
          'unlockedDate': DateTime.now().subtract(Duration(days: 7)).toIso8601String(),
        },
        {
          'id': '4',
          'title': 'Community Helper',
          'description': 'Helped 5 people in forums',
          'icon': 'community_helper',
          'unlocked': true,
          'unlockedDate': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        },
        {
          'id': '5',
          'title': 'Mood Master',
          'description': 'Tracked mood for 30 days',
          'icon': 'mood_master',
          'unlocked': false,
        },
        {
          'id': '6',
          'title': 'Step Champion',
          'description': 'Walked 10,000 steps in a day',
          'icon': 'step_champion',
          'unlocked': false,
        },
        {
          'id': '7',
          'title': 'Meditation Guru',
          'description': 'Completed 10 meditations',
          'icon': 'meditation_guru',
          'unlocked': false,
        },
        {
          'id': '8',
          'title': 'Journal Keeper',
          'description': 'Wrote 20 journal entries',
          'icon': 'journal_keeper',
          'unlocked': false,
        },
        {
          'id': '9',
          'title': 'Wellness Warrior',
          'description': 'Used app for 100 days',
          'icon': 'wellness_warrior',
          'unlocked': false,
        },
        {
          'id': '10',
          'title': 'Support Seeker',
          'description': 'Connected with 3 specialists',
          'icon': 'support_seeker',
          'unlocked': false,
        },
      ],
    };
  }
}

/// Service for Weekly Moods API calls
class WeeklyMoodsApiService extends ApiService {
  /// Get moods for this week
  static Future<List<Map<String, dynamic>>?> getWeeklyMoods({
    required String token,
  }) async {
    try {
      // Use mood history API with appropriate filters
      final result = await MoodApiService.getMoodHistory(
        token: token,
        limit: 7,
        page: 1,
      );
      
      if (result != null && result['success'] == true) {
        // Response structure: { "success": true, "data": { "moods": [...], "pagination": {...} } }
        List<Map<String, dynamic>> moods = [];
        
        if (result['data'] != null && result['data'] is Map) {
          final dataMap = result['data'] as Map<String, dynamic>;
          
          // Extract moods array from data.moods
          if (dataMap['moods'] != null && dataMap['moods'] is List) {
            final rawMoods = (dataMap['moods'] as List).cast<Map<String, dynamic>>();
            
            // Transform API response to include day and dayNumber
            moods = rawMoods.map((moodData) {
              // Get date from API response (could be 'date', 'createdAt', 'created_at', etc.)
              final dateStr = moodData['date']?.toString() ?? 
                             moodData['createdAt']?.toString() ?? 
                             moodData['created_at']?.toString() ?? 
                             moodData['updatedAt']?.toString() ?? 
                             moodData['updated_at']?.toString();
              
              DateTime? moodDate;
              if (dateStr != null && dateStr.isNotEmpty) {
                try {
                  // Try parsing ISO format first
                  moodDate = DateTime.parse(dateStr);
                } catch (e) {
                  try {
                    // Try parsing YYYY-MM-DD format
                    final parts = dateStr.split('T')[0].split('-');
                    if (parts.length == 3) {
                      moodDate = DateTime(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                    }
                  } catch (e2) {
                    print('Error parsing date: $dateStr');
                  }
                }
              }
              
              // If no valid date, use current date
              moodDate ??= DateTime.now();
              
              // Calculate day of week (1 = Monday, 7 = Sunday)
              final weekday = moodDate.weekday;
              
              // Map weekday to day abbreviation
              final dayAbbreviations = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
              final day = dayAbbreviations[weekday - 1];
              
              // Get day number (1-31)
              final dayNumber = moodDate.day;
              
              // Return mood data with added day and dayNumber
              return {
                ...moodData,
                'date': moodDate.toIso8601String(),
                'day': day,
                'dayNumber': dayNumber,
              };
            }).toList();
          }
        }
        
        if (moods.isNotEmpty) {
          // Sort by date (newest first, then we'll reverse to show oldest first for the week)
          moods.sort((a, b) {
            final dateA = DateTime.parse(a['date'] ?? DateTime.now().toIso8601String());
            final dateB = DateTime.parse(b['date'] ?? DateTime.now().toIso8601String());
            return dateB.compareTo(dateA); // Descending (newest first)
          });
          
          // Reverse to show oldest first (Monday to Sunday)
          moods = moods.reversed.toList();
          
          return moods;
        }
      }
      
      return _getDummyWeeklyMoods();
    } catch (e) {
      print('Error fetching weekly moods: ${ApiService.handleError(e)}');
      return _getDummyWeeklyMoods();
    }
  }

  static List<Map<String, dynamic>> _getDummyWeeklyMoods() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return [
      {
        'date': startOfWeek.add(Duration(days: 0)).toIso8601String(),
        'day': 'Mo',
        'dayNumber': 1,
        'mood': 'Happy',
      },
      {
        'date': startOfWeek.add(Duration(days: 1)).toIso8601String(),
        'day': 'Tu',
        'dayNumber': 2,
        'mood': 'Sad',
      },
      {
        'date': startOfWeek.add(Duration(days: 2)).toIso8601String(),
        'day': 'We',
        'dayNumber': 3,
        'mood': 'Anxious',
      },
      {
        'date': startOfWeek.add(Duration(days: 3)).toIso8601String(),
        'day': 'Th',
        'dayNumber': 4,
        'mood': 'Happy',
      },
      {
        'date': startOfWeek.add(Duration(days: 4)).toIso8601String(),
        'day': 'Fr',
        'dayNumber': 5,
        'mood': 'Anxious',
      },
      {
        'date': startOfWeek.add(Duration(days: 5)).toIso8601String(),
        'day': 'Sa',
        'dayNumber': 6,
        'mood': 'Angry',
      },
      {
        'date': startOfWeek.add(Duration(days: 6)).toIso8601String(),
        'day': 'Su',
        'dayNumber': 7,
        'mood': 'Happy',
      },
    ];
  }
}

/// Service for User Profile API calls
class UserProfileApiService extends ApiService {
  /// Update user profile image (base64)
  static Future<bool> updateUserImage({
    required String token,
    required String base64Image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/profile/image'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'image': base64Image,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating user image: ${ApiService.handleError(e)}');
      return false;
    }
  }
}
