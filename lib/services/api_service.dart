import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

/// Service for Notifications API calls
class NotificationsApiService extends ApiService {
  /// Get notifications with filters
  static Future<List<Map<String, dynamic>>?> getNotifications({
    required String token,
    int limit = 10,
    int offset = 1,
    String? date,
    String? id,
    String? type,
  }) async {
    try {
      final body = <String, dynamic>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      
      if (date != null && date.isNotEmpty) body['date'] = date;
      if (id != null && id.isNotEmpty) body['id'] = id;
      if (type != null && type.isNotEmpty) body['type'] = type;

      final response = await http.post(
        Uri.parse('$baseUrl/reached_specialist'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map && data['data'] != null) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching notifications: ${ApiService.handleError(e)}');
      return null;
    }
  }

  /// Mark notifications as read
  static Future<bool> markAsRead({
    required String token,
    required List<String> ids,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mark_read'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({'ids': ids}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error marking notifications as read: ${ApiService.handleError(e)}');
      return false;
    }
  }

  /// Delete notifications
  static Future<bool> deleteNotifications({
    required String token,
    required List<String> ids,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_notifications'),
        headers: ApiService.getHeaders(token: token),
        body: json.encode({'ids': ids}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error deleting notifications: ${ApiService.handleError(e)}');
      return false;
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
      // final response = await http.get(
      //   Uri.parse('$baseUrl/achievements/recent'),
      //   headers: ApiService.getHeaders(token: token),
      // );
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   if (data is List) {
      //     return data.cast<Map<String, dynamic>>();
      //   }
      //   return [];
      // }
      
      // Dummy data for now
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
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
      // final response = await http.get(
      //   Uri.parse('$baseUrl/achievements'),
      //   headers: ApiService.getHeaders(token: token),
      // );
      // if (response.statusCode == 200) {
      //   return json.decode(response.body);
      // }
      
      // Dummy data for now
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
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
      // TODO: Replace with actual API call when ready
      // final response = await http.get(
      //   Uri.parse('$baseUrl/mood/weekly'),
      //   headers: ApiService.getHeaders(token: token),
      // );
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   if (data is List) {
      //     return data.cast<Map<String, dynamic>>();
      //   }
      //   return [];
      // }
      
      // Dummy data for now
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay
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

