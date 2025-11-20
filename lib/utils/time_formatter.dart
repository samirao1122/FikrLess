class TimeFormatter {
  /// Format timestamp to relative time string
  /// Returns: "2 days ago", "yesterday", "a week ago", "a month ago", etc.
  static String formatRelativeTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) {
      return '';
    }

    try {
      DateTime? dateTime;
      
      // Try parsing ISO format first
      try {
        dateTime = DateTime.parse(timestamp);
      } catch (e) {
        // Try other common formats
        try {
          // Try parsing as simple date format
          final parts = timestamp.split(' ');
          if (parts.length >= 2) {
            final dateParts = parts[0].split('-');
            final timeParts = parts[1].split(':');
            if (dateParts.length == 3 && timeParts.length >= 2) {
              dateTime = DateTime(
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
                int.parse(dateParts[2]),
                timeParts.length > 0 ? int.parse(timeParts[0]) : 0,
                timeParts.length > 1 ? int.parse(timeParts[1]) : 0,
              );
            }
          }
        } catch (e2) {
          return '';
        }
      }

      if (dateTime == null) return '';

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
        }
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 14) {
        return 'A week ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'A week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 60) {
        return 'A month ago';
      } else {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'A month ago' : '$months months ago';
      }
    } catch (e) {
      return '';
    }
  }

  /// Get initials from name
  static String getInitials(String? name) {
    if (name == null || name.isEmpty) return '??';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '??';
  }
}

