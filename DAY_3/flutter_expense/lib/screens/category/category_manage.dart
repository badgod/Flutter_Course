import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../services/database_helper.dart';
import '../../config/app_theme.dart';
import '../../config/app_styles.dart';
import '../../config/app_widgets.dart';

class CategoryManageTab extends StatefulWidget {
  const CategoryManageTab({super.key});

  @override
  State<CategoryManageTab> createState() => _CategoryManageTabState();
}

class _CategoryManageTabState extends State<CategoryManageTab> {
  final _nameController = TextEditingController();
  String _selectedType = 'EXPENSE';
  List<CategoryModel> _categories = [];
  Map<int, int> _categoryUsageCount = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final cats = await DatabaseHelper.instance.getCategories();

    // นับจำนวนการใช้งานแต่ละ category
    final Map<int, int> usage = {};
    for (var cat in cats) {
      if (cat.id != null) {
        final count = await DatabaseHelper.instance
            .getTransactionCountByCategoryId(cat.id!);
        usage[cat.id!] = count;
      }
    }

    setState(() {
      _categories = cats;
      _categoryUsageCount = usage;
      _isLoading = false;
    });
  }

  Future<void> _addCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showSnackBar('กรุณากรอกชื่อหมวดหมู่', isError: true);
      return;
    }

    await DatabaseHelper.instance.addCategory(
      CategoryModel(name: name, type: _selectedType),
    );
    _nameController.clear();
    _showSnackBar('เพิ่มหมวดหมู่สำเร็จ');
    _loadCategories();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.expenseColor : AppTheme.incomeColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _editCategory(CategoryModel category) async {
    final nameController = TextEditingController(text: category.name);
    String type = category.type;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('แก้ไขหมวดหมู่'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อหมวดหมู่',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(
                  labelText: 'ประเภท',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'INCOME', child: Text('รายรับ')),
                  DropdownMenuItem(value: 'EXPENSE', child: Text('รายจ่าย')),
                ],
                onChanged: (v) => setState(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      await DatabaseHelper.instance.updateCategory(
        CategoryModel(id: category.id, name: nameController.text, type: type),
      );
      _loadCategories();
    }
  }

  Future<void> _deleteCategory(CategoryModel category) async {
    final usageCount = _categoryUsageCount[category.id] ?? 0;

    if (usageCount > 0) {
      _showDeleteWarningDialog(category, usageCount);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteConfirmDialog(category),
    );

    if (confirm == true && category.id != null) {
      final result = await DatabaseHelper.instance.deleteCategory(category.id!);

      if (result['success']) {
        _showSnackBar('ลบหมวดหมู่สำเร็จ');
        _loadCategories();
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    }
  }

  void _showDeleteWarningDialog(CategoryModel category, int usageCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.orange, size: 48),
        title: const Text('ไม่สามารถลบได้'),
        content: Text(
          'หมวดหมู่ "${category.name}" มีรายการที่ใช้งานอยู่ $usageCount รายการ\n\n'
          'กรุณาเปลี่ยนหมวดหมู่ของรายการเหล่านั้นก่อนลบ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('เข้าใจแล้ว'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _buildAddCategorySection(),
      Divider(height: 1, color: Colors.grey.shade200),
      Expanded(
        child: _isLoading
            ? AppWidgets.buildLoading()
            : _categories.isEmpty
            ? AppWidgets.buildEmptyState(
                message: 'ยังไม่มีหมวดหมู่',
                icon: Icons.category_outlined,
              )
            : _buildCategoryList(),
      ),
    ],
  );

  Widget _buildCategoryList() => ListView.builder(
    padding: const EdgeInsets.all(AppSpacing.sm),
    itemCount: _categories.length,
    itemBuilder: (context, index) => _buildCategoryCard(_categories[index]),
  );

  Widget _buildCategoryCard(CategoryModel category) {
    final isIncome = category.type == 'INCOME';
    final usageCount = _categoryUsageCount[category.id] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? AppTheme.incomeColor.withOpacity(0.2)
              : AppTheme.expenseColor.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.savings : Icons.shopping_bag,
            color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
          ),
        ),
        title: Text(category.name, style: AppTextStyles.bodyLarge),
        subtitle: Row(
          children: [
            Text(
              isIncome ? 'รายรับ' : 'รายจ่าย',
              style: AppTextStyles.bodySmall,
            ),
            if (usageCount > 0) ...[
              const Text(' • '),
              Icon(Icons.receipt, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('$usageCount รายการ', style: AppTextStyles.bodySmall),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () => _editCategory(category),
              tooltip: 'แก้ไข',
            ),
            IconButton(
              icon: Icon(
                usageCount > 0 ? Icons.delete_outline : Icons.delete,
                color: usageCount > 0 ? Colors.grey : AppTheme.expenseColor,
              ),
              onPressed: () => _deleteCategory(category),
              tooltip: usageCount > 0 ? 'ไม่สามารถลบได้ (มีการใช้งาน)' : 'ลบ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCategorySection() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เพิ่มหมวดหมู่ใหม่', style: AppTextStyles.heading4),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _buildNameInput()),
            const SizedBox(width: AppSpacing.sm),
            _buildTypeDropdown(),
            _buildAddButton(),
          ],
        ),
      ],
    ),
  );

  Widget _buildNameInput() => TextField(
    controller: _nameController,
    decoration: const InputDecoration(
      labelText: 'ชื่อหมวดหมู่',
      prefixIcon: Icon(Icons.category),
      border: OutlineInputBorder(),
    ),
    onSubmitted: (_) => _addCategory(),
  );

  Widget _buildTypeDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(AppRadius.md),
      color: Colors.grey.shade50,
    ),
    child: DropdownButton<String>(
      value: _selectedType,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(
          value: 'INCOME',
          child: Row(
            children: [
              Icon(Icons.arrow_downward, color: AppTheme.incomeColor),
              SizedBox(width: 8),
              Text('รายรับ'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'EXPENSE',
          child: Row(
            children: [
              Icon(Icons.arrow_upward, color: AppTheme.expenseColor),
              SizedBox(width: 8),
              Text('รายจ่าย'),
            ],
          ),
        ),
      ],
      onChanged: (v) => setState(() => _selectedType = v!),
    ),
  );

  Widget _buildAddButton() => IconButton.filled(
    onPressed: _addCategory,
    icon: const Icon(Icons.add),
    iconSize: 28,
    style: IconButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  Widget _buildDeleteConfirmDialog(CategoryModel category) => AlertDialog(
    icon: const Icon(Icons.delete_forever, color: Colors.red, size: 48),
    title: const Text('ยืนยันการลบ'),
    content: Text('ต้องการลบหมวดหมู่ "${category.name}" หรือไม่?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('ยกเลิก'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        style: FilledButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('ลบ'),
      ),
    ],
  );
}
