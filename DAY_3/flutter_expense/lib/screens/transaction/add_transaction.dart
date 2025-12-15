import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../services/database_helper.dart';
import '../../config/app_theme.dart';
import '../../config/app_styles.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'EXPENSE';
  int? _selectedCategoryId;
  List<CategoryModel> _categories = [];
  DateTime _selectedDate = DateTime.now();
  int _userId = 1;

  @override
  void initState() {
    super.initState();
    _loadUserAndCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndCategories() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 1;

    final cats = await DatabaseHelper.instance.getCategories();
    setState(() {
      _categories = cats;
      _updateCategoryDropdown();
    });
  }

  void _updateCategoryDropdown() {
    final filtered = _categories.where((c) => c.type == _type).toList();
    if (filtered.isNotEmpty) {
      _selectedCategoryId = filtered.first.id;
    } else {
      _selectedCategoryId = null;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty ||
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: AppTheme.expenseColor,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('กรุณาระบุจำนวนเงินที่ถูกต้อง'),
          backgroundColor: AppTheme.expenseColor,
        ),
      );
      return;
    }

    final transaction = TransactionModel(
      title: _titleController.text.trim(),
      amount: amount,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      type: _type,
      categoryId: _selectedCategoryId!,
      userId: _userId,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    await DatabaseHelper.instance.addTransaction(transaction);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories
        .where((c) => c.type == _type)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('เพิ่มรายการใหม่')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'INCOME',
                  label: Text('รายรับ'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: 'EXPENSE',
                  label: Text('รายจ่าย'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _type = newSelection.first;
                  _updateCategoryDropdown();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return _type == 'INCOME'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2);
                  }
                  return Colors.transparent;
                }),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'รายการ (เช่น ค่าข้าว)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'จำนวนเงิน',
                border: OutlineInputBorder(),
                suffixText: 'บาท',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'หมวดหมู่',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: filteredCategories.map((c) {
                return DropdownMenuItem(value: c.id, child: Text(c.name));
              }).toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
              hint: const Text('เลือกหมวดหมู่'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'หมายเหตุ (ถ้ามี)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      'วันที่: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      style: AppTextStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_circle),
                label: const Text('บันทึก', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
