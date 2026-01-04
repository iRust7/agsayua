import 'package:intl/intl.dart';

/// App Formatters - Centralized formatting utilities
class AppFormatters {
  // Currency Formatting
  static String currency(num amount) {
    return CurrencyFormatter.format(amount);
  }
  
  static String currencyCompact(num amount) {
    return CurrencyFormatter.formatCompact(amount);
  }
  
  // Date Formatting
  static String date(DateTime date) {
    return DateFormatter.formatDate(date);
  }
  
  static String dateTime(DateTime date) {
    return DateFormatter.formatDateTime(date);
  }
  
  static String time(DateTime date) {
    return DateFormatter.formatTime(date);
  }
  
  static String relativeTime(DateTime date) {
    return DateFormatter.formatRelative(date);
  }
  
  // Number Formatting
  static String number(num value) {
    return NumberFormatter.format(value);
  }
  
  static String numberCompact(num value) {
    return NumberFormatter.formatCompact(value);
  }
}

/// Currency Formatter
class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: 'Rp ',
    decimalDigits: 0,
    locale: 'id_ID',
  );
  
  static String format(num amount) {
    return _formatter.format(amount);
  }
  
  static String formatCompact(num amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}Rb';
    }
    return format(amount);
  }
}

/// Date Formatter
class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${difference.inDays >= 730 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays >= 60 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

/// Number Formatter
class NumberFormatter {
  static String format(num number) {
    return NumberFormat.decimalPattern().format(number);
  }
  
  static String formatCompact(num number) {
    return NumberFormat.compact().format(number);
  }
}
