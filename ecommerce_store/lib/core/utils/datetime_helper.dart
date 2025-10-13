import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }
  
  static String formatTime(DateTime date, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(date);
  }
  
  static String formatDateTime(DateTime date, {String pattern = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(pattern).format(date);
  }
  
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  static DateTime? tryParse(String dateString, {String? format}) {
    try {
      if (format != null) {
        return DateFormat(format).parse(dateString);
      }
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}