import 'package:flutter/material.dart';
import 'app_styles.dart';

/// คลาสรวม Reusable Widgets ที่ใช้บ่อยทั่วแอป
/// รวม Card, Section Title, Empty State, Loading และ Divider
class AppWidgets {
  /// สร้าง Card แบบสวยงามด้วย rounded corners และ elevation
  static Widget buildCard({
    required Widget child,
    EdgeInsets? padding,
    Color? color,
  }) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    color: color,
    child: Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      child: child,
    ),
  );

  /// สร้างหัวข้อ section พร้อม icon (ถ้ามี)
  static Widget buildSectionTitle(String title, {IconData? icon}) => Padding(
    padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.md),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24, color: const Color(0xFF00897B)),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(title, style: AppTextStyles.heading4),
      ],
    ),
  );

  /// แสดงสถานะว่างเปล่า (เมื่อไม่มีข้อมูล)
  static Widget buildEmptyState({required String message, IconData? icon}) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );

  /// แสดง Loading Indicator เมื่อกำลังโหลดข้อมูล
  static Widget buildLoading() =>
      const Center(child: CircularProgressIndicator());

  /// สร้างเส้นแบ่งส่วน (Divider)
  static Widget buildDivider() =>
      Divider(height: 1, thickness: 1, color: Colors.grey.shade200);
}
