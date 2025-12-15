/// Model สำหรับรายการธุรกรรมการเงิน (รายรับ-รายจ่าย)
/// เก็บข้อมูลแต่ละรายการที่ผู้ใช้บันทึก
class TransactionModel {
  final int? id; // Primary key ในฐานข้อมูล
  final String title; // หัวข้อรายการ เช่น "ซื้อของ", "รับเงินเดือน"
  final double amount; // จำนวนเงิน
  final String date; // วันที่ทำรายการ (รูปแบบ yyyy-MM-dd)
  final String type; // ประเภท: 'INCOME' (รายรับ) หรือ 'EXPENSE' (รายจ่าย)
  final int categoryId; // Foreign key อ้างอิงไปยัง category
  final int userId; // Foreign key อ้างอิงไปยัง user
  final String? note; // หมายเหตุเพิ่มเติม (optional)

  // สำหรับแสดงผล (ไม่เก็บใน DB แต่ได้จาก JOIN query)
  String? categoryName; // ชื่อหมวดหมู่สำหรับแสดงผล

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.categoryId,
    required this.userId,
    this.note,
    this.categoryName,
  });

  /// แปลง TransactionModel object เป็น Map สำหรับบันทึกลงฐานข้อมูล
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date,
    'type': type,
    'category_id': categoryId,
    'user_id': userId,
    'note': note,
  };

  /// สร้าง TransactionModel object จาก Map ที่ดึงจากฐานข้อมูล
  /// รองรับ category_name จาก JOIN query สำหรับแสดงผล
  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'],
        title: map['title'],
        amount: map['amount'],
        date: map['date'],
        type: map['type'],
        categoryId: map['category_id'],
        userId: map['user_id'],
        note: map['note'],
        categoryName: map['category_name'], // จาก JOIN query
      );

  /// สร้าง copy ของ TransactionModel พร้อมแก้ไขค่าที่ต้องการ
  /// ใช้สำหรับอัพเดทข้อมูลบางส่วนโดยไม่ต้องสร้าง object ใหม่ทั้งหมด
  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? date,
    String? type,
    int? categoryId,
    int? userId,
    String? note,
    String? categoryName,
  }) => TransactionModel(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    type: type ?? this.type,
    categoryId: categoryId ?? this.categoryId,
    userId: userId ?? this.userId,
    note: note ?? this.note,
    categoryName: categoryName ?? this.categoryName,
  );
}
