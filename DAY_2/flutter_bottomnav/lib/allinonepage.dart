import 'package:flutter/material.dart';

class AllInOnePage extends StatefulWidget {
  @override
  _AllInOnePageState createState() => _AllInOnePageState();
}

class _AllInOnePageState extends State<AllInOnePage> {
  // State Variables
  int _bottomNavIndex = 0;
  bool _isNotificationOn = true;
  List<bool> _toggleSelections = [true, false, false];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // --- 1. AppBar & Actions ---
      appBar: AppBar(
        title: Text("Ultimate Showcase"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // IconButton with Badge
          IconButton(
            onPressed: () {},
            icon: Badge(label: Text('3'), child: Icon(Icons.notifications)),
          ),
        ],
      ),

      // --- 2. Drawer (Side Menu) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              accountName: Text("Flutter Dev"),
              accountEmail: Text("dev@flutter.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "F",
                  style: TextStyle(fontSize: 40, color: Colors.indigo),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),

      // --- 3. Body (SingleChildScrollView for overflow protection) ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section A: Stack & Positioned (Header) ---
            Stack(
              clipBehavior: Clip.none, // ยอมให้ Widget ล้นกรอบได้
              alignment: Alignment.center,
              children: [
                // Background Image
                Container(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    'https://picsum.photos/800/400',
                    fit: BoxFit.cover,
                  ),
                ),
                // Profile Image overlapping
                Positioned(
                  bottom: -40, // ดันลงมาข้างล่างให้เกินขอบ
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage: NetworkImage(
                            'https://picsum.photos/200',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 50), // เว้นระยะให้ Profile Image
            // --- Section B: Text & Inputs ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Welcome back, Developer!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This page demonstrates layout composition.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),

                  // TextField
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: "Update Status",
                      hintText: "What's on your mind?",
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // --- Section C: Row & Buttons (Interaction) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton
                  ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text("Post"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Show Alert Dialog
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Success"),
                          content: Text(
                            "Status updated: ${_textController.text}",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // OutlinedButton
                  OutlinedButton(
                    onPressed: () {
                      _textController.clear();
                    },
                    child: Text("Clear"),
                  ),
                ],
              ),
            ),

            Divider(height: 40, thickness: 1),

            // --- Section D: Switches & Toggles ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Notify Me",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _isNotificationOn,
                        activeColor: Colors.indigo,
                        onChanged: (val) =>
                            setState(() => _isNotificationOn = val),
                      ),
                    ],
                  ),
                  ToggleButtons(
                    children: [
                      Icon(Icons.list),
                      Icon(Icons.grid_view),
                      Icon(Icons.map),
                    ],
                    isSelected: _toggleSelections,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (index) {
                      setState(() {
                        for (int i = 0; i < _toggleSelections.length; i++) {
                          _toggleSelections[i] = i == index;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

            // --- Section E: Horizontal List (Gallery) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "My Gallery",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 120, // ต้องกำหนดความสูงให้ ListView แนวนอน
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/100/100?random=$index',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- Section F: GridView (Dashboard Menu) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Quick Menu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2, // 2 คอลัมน์
                shrinkWrap:
                    true, // สำคัญ! ให้ GridView สูงเท่าเนื้อหา (เพราะอยู่ใน ScrollView)
                physics:
                    NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView เอง
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _buildMenuCard(Icons.analytics, "Analytics", Colors.orange),
                  _buildMenuCard(Icons.attach_money, "Earnings", Colors.green),
                  _buildMenuCard(Icons.people, "Team", Colors.blue),
                  _buildMenuCard(Icons.support_agent, "Support", Colors.purple),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // --- 4. BottomNavigationBar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Badge(label: Text("9+"), child: Icon(Icons.message)),
            label: "Chat",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Helper Widget สำหรับการ์ดเมนู
  Widget _buildMenuCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
