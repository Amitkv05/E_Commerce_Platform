import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  // static const Color primary = Color(0xFF4A90E2);
  static const Color primary = const Color.fromRGBO(252, 53, 76, 1);
  // static const Color primaryLight = Color(0xFF7AB8F5);
  // static const Color primaryDark = Color(0xFF357ABD);

  // Secondary Colors
  static const Color secondary = Color(0xFF50C878);
  static const Color secondaryLight = Color(0xFF7CD89B);
  static const Color secondaryDark = Color(0xFF3A9B5C);

  // Categories background Colors
  static Color categories = Colors.yellow;
  static Color categoriesLight = Colors.yellow.shade300;
  static Color categoriesDark = Colors.yellow.shade700;

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color removeButton = Color(0xFFEF4444);
  static Color buttonSecondary = const Color(0xFF6C757D);
  static Color buttonDisabled = const Color(0xFFC4C4C4);

  // Accent Colors
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentLight = Color(0xFFFFA8A8);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6B7280);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyMedium = Color(0xFFE5E7EB);
  static const Color greyDark = Color(0xFF374151);

  // Success, Warning, Error
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFAFAFA);
  static Color info = const Color(0xFF1976D2);

  static MaterialColor primarySwatch = MaterialColor(0xFF4A90E2, <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF2196F3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
}
