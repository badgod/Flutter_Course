import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ), // เปิดใช้ Material 3 เพื่อ Badge สวยๆ
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // เก็บสถานะว่าอยู่หน้าไหน (เริ่มที่ 0)

  // รายการหน้าจอที่จะแสดง (เปลี่ยนตาม BottomNav)
  final List<Widget> _pages = [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 30))),
    Center(child: Text('Shopping Cart', style: TextStyle(fontSize: 30))),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 30))),
  ];

  // ฟังก์ชันเปลี่ยนหน้า
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),

      //  3. Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // ลบ Padding บนสุดออกให้สีเต็มจอ
          children: [
            // ส่วนหัว Drawer
            UserAccountsDrawerHeader(
              accountName: Text("Somchai Jaidee"),
              accountEmail: Text("somchai@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("S", style: TextStyle(fontSize: 40)),
              ),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),
            // รายการเมนูใน Drawer
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // ปิด Drawer
                // ใส่ Code เปลี่ยนหน้าตรงนี้
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // แสดงผลหน้าจอตาม Index ที่เลือก
      body: _pages[_selectedIndex],

      // ---------------- 1. & 2. BottomNavigationBar + Badge ----------------
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // ปุ่มที่ 1: Home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

          // ปุ่มที่ 2: Cart (ใส่ Badge แจ้งเตือน)
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('5'), // เลขแจ้งเตือน
              backgroundColor: Colors.red,
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),

          // ปุ่มที่ 3: Profile
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex, // ระบุว่าปุ่มไหนต้อง Active
        selectedItemColor: Colors.blueAccent, // สีปุ่มที่ถูกเลือก
        unselectedItemColor: Colors.grey, // สีปุ่มที่ไม่ได้เลือก
        onTap: _onItemTapped, // ฟังก์ชันเมื่อกดปุ่ม
        type: BottomNavigationBarType.fixed, // ถ้ามีปุ่ม > 3 ต้องใช้ type นี้
      ),
    );
  }
}
