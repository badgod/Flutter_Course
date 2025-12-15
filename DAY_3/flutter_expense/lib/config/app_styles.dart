import 'package:flutter/material.dart';

/// คลาสสำหรับกำหนดรูปแบบ Text Styles ที่ใช้ทั่วแอป
/// รวม heading, body text, caption, button text และ amount styles
class AppTextStyles {
  // Headings - หัวข้อขนาดต่างๆ
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF212121),
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF212121),
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF212121),
  );

  // Body Text - ข้อความทั่วไป
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF212121),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF212121),
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF757575),
  );

  // Special - สไตล์พิเศษ
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF9E9E9E),
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Amount Styles - สไตล์สำหรับแสดงจำนวนเงิน
  static const TextStyle amountLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle amountMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle income = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4CAF50),
  );

  static TextStyle expense = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFFE53935),
  );
}

/// คลาสสำหรับกำหนดขนาดช่องว่าง (Spacing) ที่ใช้ทั่วแอป
/// ใช้สำหรับ Padding, Margin และการจัดวาง UI elements
class AppSpacing {
  static const double xs = 4.0; // Extra Small
  static const double sm = 8.0; // Small
  static const double md = 16.0; // Medium
  static const double lg = 24.0; // Large
  static const double xl = 32.0; // Extra Large
  static const double xxl = 48.0; // Extra Extra Large
}

/// คลาสสำหรับกำหนดขนาดความโค้งมุม (Border Radius)
/// ใช้สำหรับ Card, Container, Button และ UI elements ที่ต้องการมุมมน
class AppRadius {
  static const double sm = 8.0; // Small
  static const double md = 12.0; // Medium
  static const double lg = 16.0; // Large
  static const double xl = 24.0; // Extra Large
  static const double full = 999.0; // มุมมนเต็มวงกลม
}
