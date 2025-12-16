import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_node_store/components/custom_textfield.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/screens/products/components/product_image.dart';

class ProductForm extends StatefulWidget {
  final ProductModel product;
  final Function(File? file) callBackSetImage;
  final GlobalKey<FormState> formKey;

  const ProductForm(
    this.product, {
    required this.callBackSetImage,
    required this.formKey,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพสินค้า
            _ProductImageSection(
              callBackSetImage: widget.callBackSetImage,
              image: widget.product.image,
            ),
            const SizedBox(height: 24),

            // ข้อมูลพื้นฐาน
            _FormSectionCard(
              title: 'ข้อมูลพื้นฐาน',
              icon: Icons.info_outline,
              children: [
                _ProductNameField(product: widget.product),
                const SizedBox(height: 16),
                _ProductBarcodeField(product: widget.product),
                const SizedBox(height: 16),
                _ProductDescriptionField(product: widget.product),
              ],
            ),
            const SizedBox(height: 16),

            // ราคาและจำนวน
            _FormSectionCard(
              title: 'ราคาและจำนวน',
              icon: Icons.price_check_outlined,
              children: [
                _PriceAndStockRow(product: widget.product),
              ],
            ),
            const SizedBox(height: 16),

            // ข้อมูลเพิ่มเติม
            _FormSectionCard(
              title: 'ข้อมูลเพิ่มเติม',
              icon: Icons.settings_outlined,
              children: [
                _AdditionalInfoRow(product: widget.product),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION WIDGETS
// ============================================================================

/// Widget สำหรับแสดงรูปภาพสินค้า
class _ProductImageSection extends StatelessWidget {
  final Function(File? file) callBackSetImage;
  final String? image;

  const _ProductImageSection({
    required this.callBackSetImage,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'รูปภาพสินค้า',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ProductImage(
              callBackSetImage,
              image: image,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget สำหรับแสดง Section ของฟอร์ม
class _FormSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _FormSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FORM FIELD WIDGETS
// ============================================================================

/// ฟิลด์ชื่อสินค้า
class _ProductNameField extends StatelessWidget {
  final ProductModel product;

  const _ProductNameField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.name.toString(),
      obscureText: false,
      hintText: 'ชื่อสินค้า',
      prefixIcon: const Icon(Icons.shopping_bag_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกชื่อสินค้า';
        }
        return null;
      },
      onSaved: (value) => product.name = value!,
    );
  }
}

/// ฟิลด์บาร์โค้ด
class _ProductBarcodeField extends StatelessWidget {
  final ProductModel product;

  const _ProductBarcodeField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.barcode.toString(),
      obscureText: false,
      hintText: 'บาร์โค้ดสินค้า',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.qr_code_scanner_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกบาร์โค้ดสินค้า';
        }
        return null;
      },
      onSaved: (value) => product.barcode = value!,
    );
  }
}

/// ฟิลด์รายละเอียด
class _ProductDescriptionField extends StatelessWidget {
  final ProductModel product;

  const _ProductDescriptionField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.description.toString(),
      obscureText: false,
      hintText: 'รายละเอียดสินค้า',
      textInputType: TextInputType.multiline,
      maxLines: 5,
      prefixIcon: const Icon(Icons.description_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรายละเอียดสินค้า';
        }
        return null;
      },
      onSaved: (value) => product.description = value!,
    );
  }
}

/// แถวราคาและจำนวน
class _PriceAndStockRow extends StatelessWidget {
  final ProductModel product;

  const _PriceAndStockRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceField(product: product),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StockField(product: product),
        ),
      ],
    );
  }
}

/// ฟิลด์ราคา
class _PriceField extends StatelessWidget {
  final ProductModel product;

  const _PriceField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.price.toString(),
      obscureText: false,
      hintText: 'ราคาสินค้า (บาท)',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.attach_money_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกราคา';
        }
        if (int.tryParse(value) == null) {
          return 'กรุณากรอกตัวเลข';
        }
        return null;
      },
      onSaved: (value) => product.price = int.parse(value!),
    );
  }
}

/// ฟิลด์จำนวน
class _StockField extends StatelessWidget {
  final ProductModel product;

  const _StockField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.stock.toString(),
      obscureText: false,
      hintText: 'จำนวนสินค้า (ชิ้น)',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.inventory_2_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกจำนวน';
        }
        if (int.tryParse(value) == null) {
          return 'กรุณากรอกตัวเลข';
        }
        return null;
      },
      onSaved: (value) => product.stock = int.parse(value!),
    );
  }
}

/// แถวข้อมูลเพิ่มเติม
class _AdditionalInfoRow extends StatelessWidget {
  final ProductModel product;

  const _AdditionalInfoRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CategoryField(product: product),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _UserField(product: product),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _StatusField(product: product),
      ],
    );
  }
}

/// ฟิลด์หมวดหมู่
class _CategoryField extends StatelessWidget {
  final ProductModel product;

  const _CategoryField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.categoryId.toString(),
      obscureText: false,
      hintText: 'หมวดหมู่',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.category_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกหมวดหมู่';
        }
        return null;
      },
      onSaved: (value) => product.categoryId = int.parse(value!),
    );
  }
}

/// ฟิลด์ผู้ใช้
class _UserField extends StatelessWidget {
  final ProductModel product;

  const _UserField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.userId.toString(),
      obscureText: false,
      hintText: 'ผู้ใช้',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.person_outline),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกผู้ใช้';
        }
        return null;
      },
      onSaved: (value) => product.userId = int.parse(value!),
    );
  }
}

/// ฟิลด์สถานะ
class _StatusField extends StatelessWidget {
  final ProductModel product;

  const _StatusField({required this.product});

  @override
  Widget build(BuildContext context) {
    return customTextFieldProduct(
      initialValue: product.statusId.toString(),
      obscureText: false,
      hintText: 'สถานะ (1=Active, 0=Inactive)',
      textInputType: TextInputType.number,
      prefixIcon: const Icon(Icons.toggle_on_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกสถานะ';
        }
        return null;
      },
      onSaved: (value) => product.statusId = int.parse(value!),
    );
  }
}
