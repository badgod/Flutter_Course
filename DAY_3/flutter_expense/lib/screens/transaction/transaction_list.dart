import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/transaction_model.dart';
import '../../services/database_helper.dart';
import '../../config/app_theme.dart';
import '../../config/app_styles.dart';
import '../../config/app_widgets.dart';

class TransactionListTab extends StatefulWidget {
  const TransactionListTab({super.key});

  @override
  State<TransactionListTab> createState() => _TransactionListTabState();
}

// ignore: library_private_types_in_public_api
class _TransactionListTabState extends State<TransactionListTab> {
  late Future<List<TransactionModel>> _transactionsFuture = Future.value([]);
  int _userId = 1;

  @override
  void initState() {
    super.initState();
    _loadUserAndRefresh();
  }

  @override
  void didUpdateWidget(covariant TransactionListTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refresh();
  }

  Future<void> _loadUserAndRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 1;
    _refresh();
  }

  void _refresh() {
    setState(() {
      _transactionsFuture = DatabaseHelper.instance.getTransactions(
        userId: _userId,
      );
    });
  }

  Future<void> _editTransaction(TransactionModel transaction) async {
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(
      text: transaction.amount.toString(),
    );
    final noteController = TextEditingController(text: transaction.note ?? '');
    String type = transaction.type;
    int? selectedCategoryId = transaction.categoryId;
    DateTime selectedDate = DateTime.parse(transaction.date);

    final categories = await DatabaseHelper.instance.getCategories();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogSetState) {
          final filteredCategories = categories
              .where((c) => c.type == type)
              .toList();

          return AlertDialog(
            title: const Text('แก้ไขรายการ'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'รายละเอียด',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'จำนวนเงิน',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                      suffixText: 'บาท',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    decoration: const InputDecoration(
                      labelText: 'ประเภท',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.swap_vert),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'INCOME', child: Text('รายรับ')),
                      DropdownMenuItem(
                        value: 'EXPENSE',
                        child: Text('รายจ่าย'),
                      ),
                    ],
                    onChanged: (v) {
                      dialogSetState(() {
                        type = v!;
                        selectedCategoryId = null;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<int>(
                    initialValue:
                        filteredCategories.any(
                          (c) => c.id == selectedCategoryId,
                        )
                        ? selectedCategoryId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'หมวดหมู่',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: filteredCategories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        dialogSetState(() => selectedCategoryId = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'หมายเหตุ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ListTile(
                    title: const Text('วันที่'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(selectedDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        dialogSetState(() => selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
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
          );
        },
      ),
    );

    if (result == true &&
        titleController.text.trim().isNotEmpty &&
        selectedCategoryId != null) {
      await DatabaseHelper.instance.updateTransaction(
        TransactionModel(
          id: transaction.id,
          title: titleController.text.trim(),
          amount: double.tryParse(amountController.text) ?? 0,
          date: DateFormat('yyyy-MM-dd').format(selectedDate),
          type: type,
          categoryId: selectedCategoryId!,
          userId: _userId,
          note: noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
        ),
      );
      _refresh();
    }
  }

  Future<void> _deleteTransaction(TransactionModel transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.delete_forever, color: Colors.red, size: 48),
        title: const Text('ยืนยันการลบ'),
        content: Text('ต้องการลบรายการ "${transaction.title}" หรือไม่?'),
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
      ),
    );

    if (confirm == true && transaction.id != null) {
      await DatabaseHelper.instance.deleteTransaction(transaction.id!);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<TransactionModel>>(
    future: _transactionsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return AppWidgets.buildLoading();
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return AppWidgets.buildEmptyState(
          message: 'ยังไม่มีรายการบันทึก',
          icon: Icons.receipt_long_outlined,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) =>
            _buildTransactionCard(snapshot.data![index]),
      );
    },
  );

  Widget _buildTransactionCard(TransactionModel item) {
    final isIncome = item.type == 'INCOME';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? AppTheme.incomeColor.withOpacity(0.2)
              : AppTheme.expenseColor.withOpacity(0.2),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
          ),
        ),
        title: Text(item.title, style: AppTextStyles.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    item.categoryName ?? 'ไม่ระบุ',
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(' • '),
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(item.date)),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            if (item.note != null && item.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.note, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.note!,
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'} ${NumberFormat("#,##0.00").format(item.amount)}',
              style: TextStyle(
                color: isIncome ? AppTheme.incomeColor : AppTheme.expenseColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editTransaction(item);
                } else if (value == 'delete') {
                  _deleteTransaction(item);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text('แก้ไข'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text('ลบ'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
