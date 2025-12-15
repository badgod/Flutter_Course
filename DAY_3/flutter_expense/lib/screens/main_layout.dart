import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login_screen.dart';
import 'dashboard/dashboard_tab.dart';
import 'transaction/transaction_list.dart';
import 'transaction/add_transaction.dart';
import 'category/category_manage.dart';
import 'profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  String _userNickname = '';

  // ใช้ Key เพื่อบังคับให้ Widget rebuild
  Key _dashboardKey = UniqueKey();
  Key _transactionKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNickname = prefs.getString('nickname') ?? 'ผู้ใช้งาน';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _refreshData() {
    // Refresh ข้อมูลโดยสร้าง Key ใหม่เพื่อบังคับให้ Widget rebuild
    setState(() {
      _dashboardKey = UniqueKey();
      _transactionKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardTab(key: _dashboardKey),
      TransactionListTab(key: _transactionKey),
      const CategoryManageTab(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 3 ? 'ข้อมูลส่วนตัว' : 'สวัสดี, $_userNickname',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
                // ถ้ามีการเพิ่มข้อมูลสำเร็จ ให้ refresh
                if (result == true) {
                  _refreshData();
                }
              },
              label: const Text('เพิ่มรายการ'),
              icon: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.pie_chart), label: 'ภาพรวม'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'รายการ'),
          NavigationDestination(icon: Icon(Icons.category), label: 'หมวดหมู่'),
          NavigationDestination(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}
