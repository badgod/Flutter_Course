import 'package:flutter/material.dart';

class ComplexLayoutExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. SingleChildScrollView: เพื่อให้ทั้งหน้าจอเลื่อนได้ถ้าเนื้อหายาว
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // 2. Column: จัดเรียงการ์ดหลายๆ ใบในแนวตั้ง
          children: [_buildProductCard(), SizedBox(height: 20)],
        ),
      ),
    );
  }

  // 3. Container: ใช้สร้างกรอบการ์ด ใส่เงาและความโค้ง
  Widget _buildProductCard() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 15,
          offset: Offset(0, 10),
        ),
      ],
    ),
    // ClipRRect ใช้ตัดขอบรูปภาพที่เกิน Container ออกตามความโค้ง
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.blueGrey[100], //(สมมุติว่าเป็นรูปภาพ)
                child: Icon(Icons.image, size: 100, color: Colors.white70),
              ),
              // 5. Positioned: ปุ่มหัวใจลอยอยู่มุมขวาบน
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: Colors.red, size: 20),
                ),
              ),
              // ป้ายลดราคาลอยอยู่มุมซ้ายล่างของรูป
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "-20%",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          //ส่วนเนื้อหาด้านล่างรูปภาพ
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wireless Headphones",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 5),
                        Text("4.5", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "High quality wireless headphones with noise cancellation.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 15),

                //ราคาและปุ่มเพิ่มลงตะกร้า
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$99.99",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.add_shopping_cart),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
