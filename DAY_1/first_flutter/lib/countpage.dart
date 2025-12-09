import 'package:flutter/material.dart';
import 'dart:math';

class CountPage extends StatefulWidget {
  @override
  CountPageState createState() => CountPageState();
}

class CountPageState extends State<CountPage> {
  var rnd = Random();
  num _r = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Number')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(_r.toString()),
            SizedBox(height: 20),
            TextButton(
              child: Text('Random Number'),
              onPressed: () {
                setState(() {
                  _r = rnd.nextInt(100);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
