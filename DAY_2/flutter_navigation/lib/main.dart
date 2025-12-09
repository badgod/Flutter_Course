import 'package:flutter/material.dart';

// 1. สร้าง Model สินค้า
class Product {
  final String name;
  final int price;
  Product(this.name, this.price);
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // ตั้งค่า Routes
      initialRoute: '/',
      routes: {
        '/': (context) => ProductListPage(),
        '/details': (context) => ProductDetailPage(),
        '/cart': (context) => CartPage(),
      },
    ),
  );
}

// --- หน้า 1: รายการสินค้า ---
class ProductListPage extends StatelessWidget {
  final List<Product> products = [
    Product('Laptop', 30000),
    Product('Mouse', 500),
    Product('Keyboard', 1200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () async {
              // รอรับผลลัพธ์จากหน้าตะกร้า (เช่น ทำรายการสำเร็จไหม)
              final result = await Navigator.pushNamed(context, '/cart');
              if (result == 'success') {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Payment Successful!")));
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text("${products[index].price} THB"),
            onTap: () {
              // ส่ง Object Product ไปหน้า Detail
              Navigator.pushNamed(
                context,
                '/details',
                arguments: products[index],
              );
            },
          );
        },
      ),
    );
  }
}

// --- หน้า 2: รายละเอียดสินค้า (รับ Arguments) ---
class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูล Product ที่ส่งมา
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Product: ${product.name}", style: TextStyle(fontSize: 24)),
            Text(
              "Price: ${product.price} THB",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Back to Shop"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            SizedBox(height: 10),

            ElevatedButton(
              child: Text("Go to Sample Page"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SamplePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// --- หน้า 3: ตะกร้าสินค้า (ส่งค่ากลับ) ---
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text("Confirm Payment"),
          onPressed: () {
            // ส่งค่า 'success' กลับไปหน้าแรก
            Navigator.pop(context, 'success');
          },
        ),
      ),
    );
  }
}

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sample Page")),
      body: Center(child: Text("This is a sample page.")),
    );
  }
}
