import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;
  List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Basic Flutter Widget')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildSimpleText(),
              SizedBox(height: 20),
              _buildSampleButton(),
              SizedBox(height: 20),
              _buildSampleTextField(),
              SizedBox(height: 20),
              _buildSamoleIcon(),
              SizedBox(height: 20),
              _buildSampleImage(),
              SizedBox(height: 20),
              _buildSampleSwitch(),
              SizedBox(height: 20),
              _buildSampleToggleButtons(),
              SizedBox(height: 20),
              _buildSampleAlertDialog(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleText() {
    return Column(
      children: [
        // แบบพื้นฐาน: ข้อความธรรมดา
        Text('Hello, Flutter!'),

        SizedBox(height: 20),
        // แบบมีสไตล์: ข้อความที่มีการปรับแต่งสไตล์
        Text(
          'Custom Styled Text',
          style: TextStyle(
            fontSize: 24,
            color: Colors.blue.shade400,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontStyle: FontStyle.italic,
          ),
        ),

        SizedBox(height: 20),

        // แบบซับซ้อน: ข้อความในกล่องที่มีการจัดรูปแบบ
        RichText(
          text: TextSpan(
            text: 'Hello ',
            style: TextStyle(color: Colors.black, fontSize: 18),
            children: [
              TextSpan(
                text: 'World',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '! Welcome to '),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSampleButton() => Column(
    children: [
      // 1. ElevatedButton (ปุ่มนูน/มีสีพื้น)
      ElevatedButton(
        onPressed: () {
          print("Pressed!");
        },
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal, // สีปุ่ม
          foregroundColor: Colors.white, // สีตัวหนังสือ
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // ความมนของปุ่ม
          ),
        ),
      ),
      SizedBox(height: 20),

      // 2. OutlinedButton (ปุ่มมีขอบ)
      OutlinedButton(
        onPressed: () {},
        child: Text('Cancel'),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red, width: 2), // สีและความหนาขอบ
        ),
      ),
      SizedBox(height: 20),

      // 3. TextButton (ปุ่มข้อความ เรียบง่าย)
      TextButton(onPressed: () {}, child: Text('Read More')),
    ],
  );

  Widget _buildSampleTextField() => Column(
    children: [
      TextField(
        obscureText: false, // ถ้าเป็นรหัสผ่านให้แก้เป็น true
        keyboardType: TextInputType.emailAddress, // รูปแบบแป้นพิมพ์
        decoration: InputDecoration(
          labelText: 'Email', // ข้อความกำกับด้านบน
          hintText: 'example@mail.com', // ข้อความจางๆ บอกตัวอย่าง
          prefixIcon: Icon(Icons.email), // ไอคอนด้านหน้า
          suffixIcon: Icon(
            Icons.check_circle,
            color: Colors.green,
          ), // ไอคอนด้านหลัง
          // เส้นขอบปกติ
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          // เส้นขอบเมื่อกดเลือก (Focus)
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );

  Widget _buildSamoleIcon() => Row(
    children: [
      // 1. Icon ธรรมดา
      Icon(Icons.favorite, color: Colors.pink, size: 40.0),

      SizedBox(width: 20),

      // 2. IconButton (กดได้)
      IconButton(
        icon: Icon(Icons.notifications),
        color: Colors.orange,
        iconSize: 40.0,
        tooltip: 'Show Notifications', // ข้อความขึ้นเมื่อกดค้าง
        onPressed: () {
          print("Notification Clicked");
        },
      ),
    ],
  );

  Widget _buildSampleImage() => Column(
    children: [
      // 1. Image จาก Asset (ไฟล์ในโปรเจค)
      Image.asset('assets/images/001.jpg', width: 300, fit: BoxFit.cover),

      SizedBox(height: 20),

      // 2. Image จาก Network (URL)
      Image.network(
        'https://picsum.photos/id/237/200/300',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),

      SizedBox(height: 20),

      // 3. รูปวงกลม (Profile)
      CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/images/avatar.jpeg'),
      ),
    ],
  );

  Widget _buildSampleSwitch() => Column(
    children: [
      Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
        },
        activeColor: Colors.green, // สีปุ่มตอนเปิด
        activeTrackColor: Colors.lightGreenAccent, // สีรางตอนเปิด
        inactiveThumbColor: Colors.grey, // สีปุ่มตอนปิด
      ),
    ],
  );

  Widget _buildSampleToggleButtons() => Column(
    children: [
      ToggleButtons(
        children: [
          Icon(Icons.format_bold),
          Icon(Icons.format_italic),
          Icon(Icons.format_underlined),
        ],
        isSelected: _selections,
        onPressed: (int index) {
          setState(() {
            // Logic สำหรับเลือกปุ่มเดียว (Radio style) หรือหลายปุ่มก็ได้
            _selections[index] = !_selections[index];
          });
        },
        color: Colors.grey, // สีปกติ
        selectedColor: Colors.white, // สีไอคอนตอนเลือก
        fillColor: Colors.blue, // สีพื้นหลังตอนเลือก
        borderRadius: BorderRadius.circular(10),
      ),
    ],
  );

  Widget _buildSampleAlertDialog() => Column(
    children: [
      ElevatedButton(
        child: Text('Show Alert'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Action"), // หัวข้อ
                content: Text(
                  "Are you sure you want to delete this item?",
                ), // เนื้อหา
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด Dialog
                    },
                  ),
                  ElevatedButton(
                    child: Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      // ทำคำสั่งลบตรงนี้
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    ],
  );
}
