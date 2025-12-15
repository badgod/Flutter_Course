/// Model สำหรับหมวดหมู่รายรับ-รายจ่าย
/// ใช้จัดกลุ่มรายการธุรกรรม เช่น เงินเดือน, อาหาร, ค่าเดินทาง
class CategoryModel {
  final int? id; // Primary key ในฐานข้อมูล
  final String name; // ชื่อหมวดหมู่ เช่น "เงินเดือน", "อาหาร"
  final String type; // ประเภท: 'INCOME' (รายรับ) หรือ 'EXPENSE' (รายจ่าย)

  CategoryModel({this.id, required this.name, required this.type});

  /// แปลง CategoryModel object เป็น Map สำหรับบันทึกลงฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'type': type};
  }

  /// สร้าง CategoryModel object จาก Map ที่ดึงมาจากฐานข้อมูล
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(id: map['id'], name: map['name'], type: map['type']);
  }
}
