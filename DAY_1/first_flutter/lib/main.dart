import 'package:flutter/material.dart';
import 'countpage.dart';
import 'calculatepage.dart';

void main() {
  runApp(MyApp());
}

/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(child: Text('สวัสดี ชาวโลก\nฉันชื่อ สุพจน์​!!!')),
      ),
    );
  }
} */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CalculatePage());
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แอบแรกของฉัน'), backgroundColor: Colors.lime),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Hello World!!!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('สวัสดี ชาวโลก\nฉันชื่อ สุพจน์​!!!'),
            SizedBox(height: 20),
            Text('Bangkok Thailand'),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                Text('01'),
                SizedBox(width: 20),
                Text('02'),
                SizedBox(width: 20),
                Text('03'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
