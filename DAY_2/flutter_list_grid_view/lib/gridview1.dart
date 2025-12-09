import 'package:flutter/material.dart';

//แบบที่ 1: GridView.count (กำหนดคอลัมน์ตายตัว)
class GridView1 extends StatelessWidget {
  const GridView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView Example')),
      body: GridView.count(
        crossAxisCount: 2, // 2 คอลัมน์
        mainAxisSpacing: 10, // ระยะห่างแนวตั้ง
        crossAxisSpacing: 10, // ระยะห่างแนวนอน
        childAspectRatio:
            0.8, // สัดส่วน กว้าง/สูง (เช่น กว้าง 1 : สูง 1.25 -> 0.8)
        padding: EdgeInsets.all(10),
        children: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
          Container(color: Colors.yellow),
        ],
      ),
    );
  }
}
