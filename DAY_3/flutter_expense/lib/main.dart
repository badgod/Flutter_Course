import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_layout.dart';

/// Entry point ของแอปพลิเคชัน
/// ต้องเรียก ensureInitialized() ก่อนใช้ async operations
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Manager Demo',
      theme: AppTheme.lightTheme,
      home: const AuthCheck(),
    );
  }
}

/// Widget สำหรับตรวจสอบสถานะการ Login
/// ถ้าผู้ใช้ Login แล้วจะไปหน้า MainLayout ถ้ายังไม่ไปหน้า LoginScreen
class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool?
  isUserLoggedIn; // null = ยังไม่รู้สถานะ, true = login แล้ว, false = ยังไม่ login

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  /// ตรวจสอบสถานะการ Login จาก SharedPreferences
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ถ้ายังไม่รู้สถานะ แสดง Loading
    if (isUserLoggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // ถ้า login แล้วไป MainLayout ถ้วไม่ไป LoginScreen
    return isUserLoggedIn! ? MainLayout() : const LoginScreen();
  }
}
