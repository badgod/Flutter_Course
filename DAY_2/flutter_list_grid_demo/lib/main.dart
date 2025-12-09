import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List vs Grid View Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShopPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ShopPage extends StatelessWidget {
  // ข้อมูลสมมติ
  final List<String> categories = [
    "All",
    "Shoes",
    "Clothes",
    "Watches",
    "Glasses",
  ];
  final List<Map<String, dynamic>> products = List.generate(
    10,
    (index) => {
      "name": "Product $index",
      "price": "\$${(index + 1) * 100}",
      "image": Icons.shopping_bag,
    },
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Shop"), backgroundColor: Colors.orange),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ส่วนที่ 1: ListView แนวนอน (Categories)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Categories",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, //เปลี่ยนเป็นแนวนอน
              itemCount: categories.length,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  // ใช้ InkWell เพื่อเพิ่มเอฟเฟกต์การแตะ
                  onTap: () {
                    // เพิ่มฟังก์ชันเมื่อแตะที่หมวดหมู่
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You tapped on ${categories[index]}'),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.orange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ส่วนที่ 2: GridView (Products)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Popular Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ใช้ Expanded เพื่อให้ GridView กินพื้นที่ที่เหลือทั้งหมด
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.75, //ปรับอัตราส่วนของแต่ละช่อง ปรับสัดส่วนให้เป็นการ์ดแนวตั้ง (สูงกว่าแนวนอน)
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  // ใช้ GestureDetector เพื่อจับการแตะที่การ์ดสินค้า
                  onTap: () {
                    SnackBar snackBar = SnackBar(
                      content: Text('You tapped on ${product["name"]}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  onDoubleTap: () =>
                      print('Double tapped on ${product["name"]}'),
                  onScaleStart: (details) =>
                      print('Scale started on ${product["name"]}'),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปภาพสินค้า (จำลองใช้ Icon แทนรูปภาพ)
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: Icon(
                              product["image"],
                              size: 80,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        // ชื่อสินค้า
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product["name"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                products[index]['price'],
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
