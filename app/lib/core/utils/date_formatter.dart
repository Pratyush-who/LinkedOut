import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimestamp(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'Recent';
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return DateFormat('MMM d, yyyy').format(dateTime);
      }
    } catch (_) {
      return 'Recent';
    }
  }

  static String formatFullDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM d, yyyy · hh:mm a').format(dateTime);
    } catch (_) {
      return '';
    }
  }
}
