/// Model สำหรับข้อมูลผู้ใช้งาน
/// ใช้เก็บข้อมูลส่วนตัวและข้อมูลการ login ของผู้ใช้
class User {
  final int?
  id; // Primary key ในฐานข้อมูล (nullable เพราะยังไม่มี id ก่อน insert)
  final String username; // ชื่อผู้ใช้สำหรับ login
  final String password; // รหัสผ่าน
  final String firstName; // ชื่อจริง
  final String lastName; // นามสกุล
  final String nickname; // ชื่อเล่น
  final String address; // ที่อยู่
  final String phone; // เบอร์โทรศัพท์
  final String email; // อีเมล

  User({
    this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.address,
    required this.phone,
    required this.email,
  });

  /// แปลง User object เป็น Map เพื่อบันทึกลงฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  /// สร้าง User object จาก Map ที่ได้จากฐานข้อมูล
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      nickname: map['nickname'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
