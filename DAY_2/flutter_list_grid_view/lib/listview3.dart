import 'package:flutter/material.dart';

//แบบที่ 3: ListView.separated (มีเส้นคั่น)
class ListView3 extends StatelessWidget {
  const ListView3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Example')),
      body: ListView.separated(
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(title: Text("Menu $index")),
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey), // เส้นคั่น
      ),
    );
  }
}
