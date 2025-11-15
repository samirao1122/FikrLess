import 'dart:convert';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';

 const String baseUrl = 'http://13.204.135.41:5003/api/v1';
const String baseUrlSignUP = 'http://13.204.135.41:5003';
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
}

/// Service for mood-related API calls
class MoodApiService extends ApiService {
  /// Get current mood from API
  static Future<Map<String, dynamic>?> getCurrentMood({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mood/current'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching mood: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Submit mood to API
  static Future<bool> submitMood({
    required String mood,
    String? notes,
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mood/submit'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'mood': mood,
          if (notes != null) 'notes': notes,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error submitting mood: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Get moods with pagination
  static Future<Map<String, dynamic>?> getMoods({
    required int limit,
    required int offset,
    required String date, // ISO format
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_modes'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'limit': limit,
          'offset': offset,
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching moods: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Update mood (POST mood API)
  static Future<bool> updateMood({
    required String mood, // ENUM format (uppercase)
    required String modeDesc, // Journal text
    required String date, // ISO format
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_mode'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({
          'mood': mood,
          'mode_desc': modeDesc,
          'Date': date,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error updating mood: ${ApiService.handleError(e)}');
      return false;
    }
  }
}

/// Service for quote of the day API calls
class QuoteApiService extends ApiService {
  /// Get quote of the day from API
  static Future<Map<String, dynamic>?> getQuoteOfTheDay({String? token}) async {
    try {
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

/// Service for step tracking API calls
class StepsApiService extends ApiService {
  /// Sync steps to API
  static Future<bool> syncSteps({
    required String steps,
    required String time,
    required String token,
  }) async {
    try {
      final headers = ApiService.getHeaders(token: token);
      headers['Content-Type'] = 'application/json';
      
      final response = await http.post(
        Uri.parse('$baseUrl/stepstaken'),
        headers: headers,
        body: json.encode({
          'steps': steps,
          'time': time,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Steps synced successfully: $steps at $time');
        return true;
      } else {
        print('Failed to sync steps: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error syncing steps: ${ApiService.handleError(e)}');
      return false;
    }
  }
}

/// Service for Spiritual Hub API calls
class SpiritualHubApiService extends ApiService {
  /// Get slider reminder images
  static Future<List<Map<String, dynamic>>?> getSliderImages({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrlSignUP/slider_img_remider'),
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

  /// Get guided meditation audios
  static Future<List<Map<String, dynamic>>?> getGuidedMeditationAudios({String? token}) async {
    try {
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

  /// Get categories for practitioners
  static Future<List<Map<String, dynamic>>?> getCategories({String? token}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_categories'),
        headers: ApiService.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['data'] != null) {
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

  /// Get practitioners with pagination
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

