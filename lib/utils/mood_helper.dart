import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Helper class to map mood names to image assets and colors
class MoodHelper {
  MoodHelper._();

  /// Map of mood names to their image asset paths
  static const Map<String, String> moodImages = {
    'Happy': 'assets/images/mood/happy.png',
    'SAD': 'assets/images/mood/sad.png',
    'HAPPY': 'assets/images/mood/happy.png',
    'ANXIOUS': 'assets/images/mood/anxious.png',
    'TIRED': 'assets/images/mood/tired.png',
    'ANGRY': 'assets/images/mood/angry.png',
    'CALM': 'assets/images/mood/calm.png',
    'Very Happy': 'assets/images/mood/happy.png',
    'Calm': 'assets/images/mood/calm.png',
    'Sad': 'assets/images/mood/sad.png',
    'Anxious': 'assets/images/mood/anxious.png',
    'Tired': 'assets/images/mood/tired.png',
    'Angry': 'assets/images/mood/angry.png',
    'Worried': 'assets/images/mood/anxious.png',
  };

  /// Map of mood names to their background colors
  static const Map<String, Color> moodColors = {
    'Happy': Color(0xFFE8F5E9), // Light green
    'HAPPY': Color(0xFFE8F5E9),
    'Sad': Color(0xFFE3F2FD), // Light blue
    'SAD': Color(0xFFE3F2FD),
    'Anxious': Color(0xFFE0F2F1), // Light teal
    'ANXIOUS': Color(0xFFE0F2F1),
    'Tired': Color(0xFFF3E5F5), // Light purple
    'TIRED': Color(0xFFF3E5F5),
    'Angry': Color(0xFFFFEBEE), // Light red
    'ANGRY': Color(0xFFFFEBEE),
    'Calm': Color(0xFFFFF9C4), // Light yellow
    'CALM': Color(0xFFFFF9C4),
  };

  /// Map of mood names to their border colors
  static const Map<String, Color> moodBorderColors = {
    'Happy': Color(0xFF4CAF50), // Green
    'HAPPY': Color(0xFF4CAF50),
    'Sad': Color(0xFF2196F3), // Blue
    'SAD': Color(0xFF2196F3),
    'Anxious': Color(0xFF009688), // Teal
    'ANXIOUS': Color(0xFF009688),
    'Tired': Color(0xFF9C27B0), // Purple
    'TIRED': Color(0xFF9C27B0),
    'Angry': Color(0xFFF44336), // Red
    'ANGRY': Color(0xFFF44336),
    'Calm': Color(0xFFFFC107), // Yellow/Amber
    'CALM': Color(0xFFFFC107),
  };

  /// Get image path for a mood
  static String? getMoodImagePath(String mood) {
    return moodImages[mood.toUpperCase()] ?? moodImages[mood];
  }

  /// Get background color for a mood
  static Color getMoodColor(String mood) {
    return moodColors[mood.toUpperCase()] ?? moodColors[mood] ?? AppColors.white;
  }

  /// Get border color for a mood
  static Color getMoodBorderColor(String mood) {
    return moodBorderColors[mood.toUpperCase()] ?? moodBorderColors[mood] ?? AppColors.accentTeal;
  }

  /// Get all available moods (6 main moods)
  static List<String> getAvailableMoods() {
    return [
      'Happy',
      'Sad',
      'Anxious',
      'Tired',
      'Angry',
      'Calm',
    ];
  }

  /// Check if mood has an image
  static bool hasMoodImage(String mood) {
    return moodImages.containsKey(mood.toUpperCase()) || moodImages.containsKey(mood);
  }

  /// Convert mood to API format (lowercase)
  /// API expects: happy, sad, anxious, tired, angry, calm
  static String toApiFormat(String mood) {
    return mood.toLowerCase();
  }

  /// Convert API mood format to display format
  static String toDisplayFormat(String mood) {
    if (mood.length <= 1) return mood;
    return mood[0] + mood.substring(1).toLowerCase();
  }
}

