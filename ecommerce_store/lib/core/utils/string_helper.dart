import 'package:intl/intl.dart';

class StringHelper {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
  
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  static bool isEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
  
  static String formatCurrency(double amount, {String symbol = '\$', int decimals = 2}) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }
  
  static String formatNumber(double number, {int decimals = 0}) {
    return number.toStringAsFixed(decimals);
  }
  
  static String generateOrderId() {
    final now = DateTime.now();
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${random.toString().padLeft(4, '0')}';
  }
}