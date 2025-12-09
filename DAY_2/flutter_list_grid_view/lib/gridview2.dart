import 'package:flutter/material.dart';

//แบบที่ 2: GridView.builder (Dynamic Grid) (แนะนำ)
class GridView2 extends StatelessWidget {
  const GridView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GridView Example')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 คอลัมน์
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: 20, // จำนวนข้อมูล
        itemBuilder: (context, index) {
          return Container(
            color: Colors.teal[100 * (index % 9)],
            child: Center(child: Text('Grid $index')),
          );
        },
      ),
    );
  }
}
