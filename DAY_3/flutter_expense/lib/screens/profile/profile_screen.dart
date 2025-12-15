import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../services/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId != null) {
      final user = await DatabaseHelper.instance.getUserById(userId);
      if (user != null) {
        setState(() {
          _currentUser = user;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _nicknameController.text = user.nickname;
          _addressController.text = user.address;
          _phoneController.text = user.phone;
          _emailController.text = user.email;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate() && _currentUser != null) {
      final updatedUser = User(
        id: _currentUser!.id,
        username: _currentUser!.username,
        password: _currentUser!.password,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        nickname: _nicknameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      await DatabaseHelper.instance.updateUser(updatedUser);

      // Update SharedPrefs nickname
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nickname', updatedUser.nickname);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('บันทึกข้อมูลเรียบร้อย')));
      }
    }
  }

  void _showChangePasswordDialog() {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เปลี่ยนรหัสผ่าน'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'รหัสผ่านใหม่'),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'ยืนยันรหัสผ่าน'),
                validator: (v) =>
                    v != passwordController.text ? 'รหัสผ่านไม่ตรงกัน' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await DatabaseHelper.instance.changePassword(
                  _currentUser!.id!,
                  passwordController.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ')),
                  );
                }
              }
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบบัญชี'),
        content: const Text(
          'คุณแน่ใจหรือไม่ที่จะลบบัญชีและข้อมูลทั้งหมด?\n'
          'การดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () async {
              // ลบข้อมูลทั้งหมด
              await DatabaseHelper.instance.deleteAccountAndAllData();

              // ลบ SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              if (mounted) {
                Navigator.pop(context); // ปิด dialog

                // แสดงข้อความลบเสร็จแล้ว
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ลบข้อมูลทั้งหมดเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                // ไปที่หน้าหลักของโปรแกรม (main layout)
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบบัญชี'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_currentUser == null) {
      return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'ชื่อผู้ใช้: ${_currentUser!.username}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'ชื่อจริง',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'นามสกุล',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อเล่น',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทร',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'ที่อยู่',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _updateProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('บันทึกการแก้ไข'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showChangePasswordDialog,
                  icon: const Icon(Icons.key),
                  label: const Text('เปลี่ยนรหัสผ่าน'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showDeleteAccountDialog,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('ลบบัญชีและข้อมูลทั้งหมด'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
