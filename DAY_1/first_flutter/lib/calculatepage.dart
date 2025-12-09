import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  @override
  CalculatePageState createState() => CalculatePageState();
}

class CalculatePageState extends State<CalculatePage> {
  num a = 15, b = 5;
  String _txt = '';

  void btn_processed({String op = ''}) {
    setState(() {
      num r = 0;
      if (op == '+') {
        r = a + b;
      } else if (op == '-') {
        r = a - b;
      }

      _txt = '$a $op $b = $r';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculate Page')),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(_txt),
            SizedBox(height: 20),
            btnPlus(),
            SizedBox(height: 20),
            btnMinus(),
          ],
        ),
      ),
    );
  }

  Widget btnMinus() => ElevatedButton(
    child: Text('$a - $b'),
    onPressed: () {
      btn_processed(op: '-');
    },
  );

  Widget btnPlus() => ElevatedButton(
    child: Text('$a + $b'),
    onPressed: () {
      btn_processed(op: '+');
    },
  );
}
