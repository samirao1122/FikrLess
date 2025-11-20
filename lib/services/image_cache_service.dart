import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for caching images as files in internal storage
/// Images are stored in app's internal directory and automatically deleted on uninstall
class ImageCacheService {
  static Directory? _cacheDir;

  /// Initialize cache directory
  static Future<void> initialize() async {
    if (_cacheDir == null) {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDir = Directory(path.join(appDir.path, 'image_cache'));
      if (!await _cacheDir!.exists()) {
        await _cacheDir!.create(recursive: true);
      }
    }
  }

  /// Get cache directory
  static Future<Directory> _getCacheDir() async {
    await initialize();
    return _cacheDir!;
  }

  /// Generate filename from user ID
  static String _getFileName(String userId) {
    // Use userId as filename (sanitize if needed)
    return 'profile_${userId.replaceAll(RegExp(r'[^\w-]'), '_')}.jpg';
  }

  /// Save base64 image to file
  /// Returns the file path if successful, null otherwise
  static Future<String?> saveImageFromBase64({
    required String userId,
    required String base64Image,
  }) async {
    try {
      if (base64Image.isEmpty) return null;

      // Extract base64 string (handle data URL format)
      String base64String = base64Image;
      if (base64Image.contains(',')) {
        base64String = base64Image.split(',')[1];
      }

      // Decode base64 to bytes
      final imageBytes = base64Decode(base64String);
      
      // Get cache directory
      final cacheDir = await _getCacheDir();
      final fileName = _getFileName(userId);
      final file = File(path.join(cacheDir.path, fileName));

      // Write to file
      await file.writeAsBytes(imageBytes);
      
      print('✅ Image saved to: ${file.path}');
      return file.path;
    } catch (e) {
      print('❌ Error saving image: $e');
      return null;
    }
  }

  /// Get image file path for a user
  /// Returns file path if exists, null otherwise
  static Future<String?> getImagePath(String userId) async {
    try {
      final cacheDir = await _getCacheDir();
      final fileName = _getFileName(userId);
      final file = File(path.join(cacheDir.path, fileName));

      if (await file.exists()) {
        return file.path;
      }
      return null;
    } catch (e) {
      print('Error getting image path: $e');
      return null;
    }
  }

  /// Get image file for a user
  /// Returns File if exists, null otherwise
  static Future<File?> getImageFile(String userId) async {
    try {
      final filePath = await getImagePath(userId);
      if (filePath != null) {
        return File(filePath);
      }
      return null;
    } catch (e) {
      print('Error getting image file: $e');
      return null;
    }
  }

  /// Check if image exists in cache
  static Future<bool> imageExists(String userId) async {
    final filePath = await getImagePath(userId);
    return filePath != null;
  }

  /// Delete image from cache
  static Future<bool> deleteImage(String userId) async {
    try {
      final filePath = await getImagePath(userId);
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Clear all cached images
  static Future<void> clearAll() async {
    try {
      final cacheDir = await _getCacheDir();
      if (await cacheDir.exists()) {
        await for (var entity in cacheDir.list()) {
          if (entity is File && entity.path.endsWith('.jpg')) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }

  /// Get cache size in bytes
  static Future<int> getCacheSize() async {
    try {
      final cacheDir = await _getCacheDir();
      int totalSize = 0;
      
      if (await cacheDir.exists()) {
        await for (var entity in cacheDir.list()) {
          if (entity is File && entity.path.endsWith('.jpg')) {
            totalSize += await entity.length();
          }
        }
      }
      
      return totalSize;
    } catch (e) {
      print('Error calculating cache size: $e');
      return 0;
    }
  }
}

