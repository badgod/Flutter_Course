import 'package:flutter/material.dart';
import 'complexlayoutexample.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Layout Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ComplexLayoutExample(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Layout Demo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContainer1(),
            SizedBox(height: 20),
            _buildContainer2(),
            SizedBox(height: 20),
            _buildStack(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer1() => Container(
    height: 200, // กำหนดความสูงเพื่อให้เห็นผลของ Vertical Alignment
    color: Colors.grey[200],
    child: Row(
      // Row: แกนหลักคือแนวนอน (ซ้าย-ขวา), แกนรองคือแนวตั้ง (บน-ล่าง)

      // spaceBetween: ชิดขอบซ้าย-ขวา ที่เหลือเว้นว่างตรงกลาง
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      // center: ให้อยู่กึ่งกลางในแนวตั้ง
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Container(color: Colors.red, width: 50, height: 50),
        Container(color: Colors.green, width: 50, height: 100),
        Container(color: Colors.green, width: 50, height: 100), // สูงกว่าเพื่อน
        Container(color: Colors.blue, width: 50, height: 50),
      ],
    ),
  );

  Widget _buildContainer2() => Container(
    width: 300,
    padding: EdgeInsets.all(20), // ดันเนื้อหาภายในเข้ามา 20
    margin: EdgeInsets.symmetric(vertical: 10), // เว้นระยะห่างจากตัวอื่น
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15), // มุมโค้ง
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // สีเงาจางๆ
          blurRadius: 10, // ความฟุ้งของเงา
          offset: Offset(0, 5), // เงาตกกระทบลงมาด้านล่าง 5 หน่วย
        ),
      ],
      border: Border.all(color: Colors.blueAccent, width: 2), // เส้นขอบ
    ),
    child: Text("I am inside a beautiful Container!"),
  );

  Widget _buildStack() => Stack(
    alignment: Alignment.center, // จัดกึ่งกลางถ้าไม่ใช้ Positioned
    children: [
      // Layer 1 (ล่างสุด): รูปภาพ
      Container(width: 200, height: 200, color: Colors.blue),

      // Layer 2: ข้อความตรงกลาง
      Text("Background", style: TextStyle(color: Colors.white)),

      // Layer 3 (บนสุด): ปุ่มแจ้งเตือนมุมขวาบน
      Positioned(
        top: 10,
        right: 10,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: Text("1", style: TextStyle(color: Colors.white)),
        ),
      ),
    ],
  );
}
