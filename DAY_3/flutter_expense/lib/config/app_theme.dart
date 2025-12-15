import 'package:flutter/material.dart';

/// คลาสสำหรับกำหนด Theme และสีสันหลักของแอป
/// รวมการกำหนดรูปแบบของ AppBar, Card, Button และ UI elements อื่นๆ
class AppTheme {
  // สีหลักของแอป (โทนสีเขียว)
  static const Color primaryColor = Color(0xFF00897B); // Teal 600
  static const Color secondaryColor = Color(0xFF26A69A); // Teal 400
  static const Color accentColor = Color(0xFF4DB6AC); // Teal 300

  // สีสำหรับรายรับ-รายจ่าย
  static const Color incomeColor = Color(0xFF4CAF50); // Green
  static const Color expenseColor = Color(0xFFE53935); // Red

  // สีพื้นฐานของ UI
  static const Color backgroundColor = Color(0xFFF5F5F5); // สีพื้นหลังของแอป
  static const Color cardColor = Colors.white; // สีของ Card
  static const Color textPrimaryColor = Color(0xFF212121); // สีข้อความหลัก
  static const Color textSecondaryColor = Color(0xFF757575); // สีข้อความรอง

  /// Theme หลักของแอป (Light Mode)
  /// กำหนดรูปลักษณ์ของ AppBar, Card, Button, Input และ widgets อื่นๆ
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: 'IBMPlexSansThai',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      background: backgroundColor,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: 'IBMPlexSansThai',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      color: cardColor,
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );
}
