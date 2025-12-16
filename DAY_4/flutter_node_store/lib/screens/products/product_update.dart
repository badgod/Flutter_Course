import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/screens/products/components/product_form.dart';
import 'package:flutter_node_store/services/rest_api.dart';

class ProductUpdate extends StatefulWidget {
  const ProductUpdate({super.key});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  // สร้าง GlobalKey สำหรับฟอร์ม
  final _formKeyUpdateProduct = GlobalKey<FormState>();

  // สร้างตัวแปรสำหรับเก็บข้อมูล Product
  late ProductModel _product;

  // ไฟล์รูปภาพ
  File? _imageFile;

  // Loading state
  bool _isLoading = false;

  // Flag เพื่อป้องกันการตั้งค่าซ้ำ
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ตั้งค่าเพียงครั้งเดียว
    if (!_isInitialized) {
      final Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;

      if (arguments != null && arguments['products'] != null) {
        final productData = arguments['products'];
        _product = ProductModel(
          id: productData['id'],
          name: productData['name'],
          description: productData['description'],
          barcode: productData['barcode'],
          stock: productData['stock'],
          price: productData['price'],
          categoryId: productData['category_id'],
          userId: productData['user_id'],
          statusId: productData['status_id'],
          image: productData['image'],
        );
        _isInitialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('แก้ไขสินค้า')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขสินค้า'),
        actions: [
          // Save Button
          if (!_isLoading)
            IconButton(
              onPressed: _saveProduct,
              icon: const Icon(Icons.save),
              tooltip: 'บันทึกข้อมูล',
            ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ProductForm(
                  _product,
                  callBackSetImage: _callBackSetImage,
                  formKey: _formKeyUpdateProduct,
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('กำลังบันทึกข้อมูล...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูล
  Future<void> _saveProduct() async {
    // Validate form
    if (!_formKeyUpdateProduct.currentState!.validate()) {
      _showSnackBar('กรุณากรอกข้อมูลให้ครบถ้วน', isError: true);
      return;
    }

    // แสดง confirmation dialog
    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    // Save form
    _formKeyUpdateProduct.currentState!.save();

    // แสดง loading
    setState(() => _isLoading = true);

    try {
      // Call API Update Product
      final response = await CallAPI().updateProductAPI(
        _product,
        imageFile: _imageFile,
      );

      if (!mounted) return;

      final body = jsonDecode(response);

      if (body['status'] == 'ok') {
        _showSnackBar('บันทึกข้อมูลสำเร็จ', isError: false);

        // รอให้ snackbar แสดงก่อนปิดหน้า
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        // ปิดหน้าจอและส่งค่ากลับไปยังหน้าก่อนหน้า
        Navigator.pop(context, true);
        Navigator.pop(context, true);

        // อัพเดทข้อมูลใหม่ล่าสุด
        refreshKey.currentState?.show();
      } else {
        _showSnackBar(
          body['message'] ?? 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('เกิดข้อผิดพลาด: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // แสดง SnackBar
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // แสดง Confirmation Dialog
  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.save, color: Colors.blue),
            SizedBox(width: 8),
            Text('ยืนยันการบันทึก'),
          ],
        ),
        content: const Text('คุณต้องการบันทึกการแก้ไขข้อมูลสินค้านี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับเลือกรูปภาพ
  void _callBackSetImage(File? imageFile) {
    if (mounted) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  @override
  void dispose() {
    // Clean up ถ้ามีการใช้ controller หรือ listener
    super.dispose();
  }
}
