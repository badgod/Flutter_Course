import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import '../../services/database_helper.dart';
import '../main_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasUser = false;

  @override
  void initState() {
    super.initState();
    _checkHasUser();
  }

  Future<void> _checkHasUser() async {
    final hasUser = await DatabaseHelper.instance.hasAnyUser();
    setState(() => _hasUser = hasUser);
  }

  Future<void> _login() async {
    final user = await DatabaseHelper.instance.loginUser(
      _usernameController.text,
      _passwordController.text,
    );

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt(
        'userId',
        user.id!,
      ); // สำคัญ: เก็บ ID ไว้ใช้หน้า Profile
      await prefs.setString('nickname', user.nickname);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icon.png', width: 120, height: 120),
              const SizedBox(height: 20),
              const Text(
                'Money Tracker',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                'เข้าสู่ระบบเพื่อจัดการการเงินของคุณ',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อผู้ใช้',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _login,
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ),
              const SizedBox(height: 16),
              if (!_hasUser)
                TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                    if (result == true) {
                      _checkHasUser(); // รีเฟรชสถานะ
                    }
                  },
                  child: const Text('ยังไม่มีบัญชี? ลงทะเบียนที่นี่'),
                ),
              if (_hasUser)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'แอปนี้รองรับเพียง 1 บัญชี (แอปส่วนตัว)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
