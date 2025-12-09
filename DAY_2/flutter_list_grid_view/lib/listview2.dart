import 'package:flutter/material.dart';

//แบบที่ 2: ListView.builder (Dynamic/Performance)
class ListView2 extends StatelessWidget {
  const ListView2({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(100, (index) => "Item $index");

    return Scaffold(
      appBar: AppBar(title: const Text('ListView Example')),
      body: ListView.builder(
        itemCount: items.length, // บอกจำนวนทั้งหมด
        itemBuilder: (context, index) {
          // index คือลำดับที่กำลังถูกสร้าง (0, 1, 2, ...)
          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              title: Text(items[index]),
              leading: CircleAvatar(child: Text('${index + 1}')),
            ),
          );
        },
      ),
    );
  }
}
