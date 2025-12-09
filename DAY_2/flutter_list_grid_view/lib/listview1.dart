import 'package:flutter/material.dart';

//แบบที่ 1: ListView (Static)
class ListView1 extends StatelessWidget {
  const ListView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Example')),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(leading: Icon(Icons.map), title: Text('Map')),
          ListTile(leading: Icon(Icons.photo), title: Text('Album')),
          ListTile(leading: Icon(Icons.phone), title: Text('Phone')),
        ],
      ),
    );
  }
}
