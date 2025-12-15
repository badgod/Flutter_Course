import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/transaction_model.dart';
import '../../services/database_helper.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

// ignore: library_private_types_in_public_api
class _DashboardTabState extends State<DashboardTab> {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // เรียกซ้ำเมื่อ Widget ถูกสร้างใหม่ (เช่น สลับ Tab ไปมา)
  @override
  void didUpdateWidget(covariant DashboardTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (mounted) {
      setState(() {
        _transactions = data;
        _isLoading = false;
      });
    }
  }

  // คำนวณข้อมูลรายวัน 7 วันย้อนหลัง
  Map<String, Map<String, double>> _calculateDailyData() {
    final now = DateTime.now();
    final Map<String, Map<String, double>> dailyData = {};

    // สร้างโครงสร้างข้อมูล 7 วันย้อนหลัง
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      dailyData[dateKey] = {'income': 0.0, 'expense': 0.0};
    }

    // รวมยอดตามวัน
    for (var t in _transactions) {
      if (dailyData.containsKey(t.date)) {
        if (t.type == 'INCOME') {
          dailyData[t.date]!['income'] =
              (dailyData[t.date]!['income'] ?? 0) + t.amount;
        } else {
          dailyData[t.date]!['expense'] =
              (dailyData[t.date]!['expense'] ?? 0) + t.amount;
        }
      }
    }

    return dailyData;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    double totalIncome = 0;
    double totalExpense = 0;
    Map<String, double> expenseCategoryData = {};
    Map<String, double> incomeCategoryData = {};

    for (var t in _transactions) {
      final categoryName = t.categoryName ?? 'ไม่ระบุ';
      if (t.type == 'INCOME') {
        totalIncome += t.amount;
        incomeCategoryData[categoryName] =
            (incomeCategoryData[categoryName] ?? 0) + t.amount;
      } else {
        totalExpense += t.amount;
        expenseCategoryData[categoryName] =
            (expenseCategoryData[categoryName] ?? 0) + t.amount;
      }
    }

    final balance = totalIncome - totalExpense;
    final dailyData = _calculateDailyData();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Balance Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.teal.shade700,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'ยอดเงินคงเหลือ',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(symbol: '฿').format(balance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryItem(
                        'รายรับ',
                        totalIncome,
                        Colors.greenAccent,
                      ),
                      _buildSummaryItem(
                        'รายจ่าย',
                        totalExpense,
                        Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // กราฟรายได้-รายจ่าย 7 วันย้อนหลัง (แท่ง)
          _buildSectionTitle('รายรับ-รายจ่าย 7 วันย้อนหลัง'),
          const SizedBox(height: 16),
          _buildDailyBarChart(dailyData),
          const SizedBox(height: 32),

          // กราฟเส้นรายรับ 7 วัน
          _buildSectionTitle('แนวโน้มรายรับ 7 วัน'),
          const SizedBox(height: 16),
          _buildIncomeLineChart(dailyData),
          const SizedBox(height: 32),

          // Pie Chart รายจ่าย
          _buildSectionTitle('สัดส่วนรายจ่ายตามหมวดหมู่'),
          const SizedBox(height: 16),
          expenseCategoryData.isEmpty
              ? const SizedBox(
                  height: 200,
                  child: Center(child: Text('ยังไม่มีข้อมูลรายจ่าย')),
                )
              : _buildPieChart(expenseCategoryData, totalExpense, false),
          const SizedBox(height: 32),

          // Pie Chart รายรับ
          _buildSectionTitle('สัดส่วนรายรับตามหมวดหมู่'),
          const SizedBox(height: 16),
          incomeCategoryData.isEmpty
              ? const SizedBox(
                  height: 200,
                  child: Center(child: Text('ยังไม่มีข้อมูลรายรับ')),
                )
              : _buildPieChart(incomeCategoryData, totalIncome, true),
          const SizedBox(height: 32),

          // กราฟแท่งรายจ่าย 7 วัน
          _buildSectionTitle('รายจ่ายรายวัน 7 วัน'),
          const SizedBox(height: 16),
          _buildExpenseBarChart(dailyData),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          NumberFormat.currency(symbol: '฿').format(amount),
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // กราฟแท่งเปรียบเทียบรายรับ-รายจ่าย
  Widget _buildDailyBarChart(Map<String, Map<String, double>> dailyData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue(dailyData) * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final date = dailyData.keys.toList()[group.x.toInt()];
                    final dateFormatted = DateFormat(
                      'dd/MM',
                    ).format(DateTime.parse(date));
                    final type = rodIndex == 0 ? 'รายรับ' : 'รายจ่าย';
                    return BarTooltipItem(
                      '$dateFormatted\n$type\n฿${rod.toY.toStringAsFixed(0)}',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dateKey = dailyData.keys.toList()[value.toInt()];
                      final date = DateTime.parse(dateKey);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '฿${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: dailyData.entries.map((entry) {
                final index = dailyData.keys.toList().indexOf(entry.key);
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['income'] ?? 0,
                      color: Colors.green,
                      width: 12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    BarChartRodData(
                      toY: entry.value['expense'] ?? 0,
                      color: Colors.red,
                      width: 12,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // กราฟเส้นรายรับ
  Widget _buildIncomeLineChart(Map<String, Map<String, double>> dailyData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1000,
                verticalInterval: 1,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 &&
                          value.toInt() < dailyData.length) {
                        final dateKey = dailyData.keys.toList()[value.toInt()];
                        final date = DateTime.parse(dateKey);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '฿${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300),
              ),
              minX: 0,
              maxX: (dailyData.length - 1).toDouble(),
              minY: 0,
              maxY: _getMaxIncomeValue(dailyData) * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: dailyData.entries.map((entry) {
                    final index = dailyData.keys.toList().indexOf(entry.key);
                    return FlSpot(index.toDouble(), entry.value['income'] ?? 0);
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.3),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final dateKey = dailyData.keys.toList()[spot.x.toInt()];
                      final date = DateTime.parse(dateKey);
                      return LineTooltipItem(
                        '${DateFormat('dd/MM').format(date)}\n฿${spot.y.toStringAsFixed(0)}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // กราฟแท่งรายจ่าย
  Widget _buildExpenseBarChart(Map<String, Map<String, double>> dailyData) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxExpenseValue(dailyData) * 1.2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final date = dailyData.keys.toList()[group.x.toInt()];
                    final dateFormatted = DateFormat(
                      'dd/MM',
                    ).format(DateTime.parse(date));
                    return BarTooltipItem(
                      '$dateFormatted\nรายจ่าย\n฿${rod.toY.toStringAsFixed(0)}',
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dateKey = dailyData.keys.toList()[value.toInt()];
                      final date = DateTime.parse(dateKey);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '฿${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: dailyData.entries.map((entry) {
                final index = dailyData.keys.toList().indexOf(entry.key);
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value['expense'] ?? 0,
                      gradient: LinearGradient(
                        colors: [Colors.red.shade400, Colors.red.shade700],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // Pie Chart
  Widget _buildPieChart(
    Map<String, double> categoryData,
    double total,
    bool isIncome,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 280,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    sections: categoryData.entries.map((e) {
                      final index = categoryData.keys.toList().indexOf(e.key);
                      return PieChartSectionData(
                        value: e.value,
                        title: '${(e.value / total * 100).toStringAsFixed(1)}%',
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        color: isIncome
                            ? Colors.green[((index % 5) + 3) * 100]
                            : Colors.primaries[index % Colors.primaries.length],
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryData.entries.map((e) {
                    final index = categoryData.keys.toList().indexOf(e.key);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green[((index % 5) + 3) * 100]
                                  : Colors.primaries[index %
                                        Colors.primaries.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              e.key,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getMaxValue(Map<String, Map<String, double>> dailyData) {
    double max = 0;
    for (var entry in dailyData.values) {
      final income = entry['income'] ?? 0;
      final expense = entry['expense'] ?? 0;
      if (income > max) max = income;
      if (expense > max) max = expense;
    }
    return max == 0 ? 1000 : max;
  }

  double _getMaxIncomeValue(Map<String, Map<String, double>> dailyData) {
    double max = 0;
    for (var entry in dailyData.values) {
      final income = entry['income'] ?? 0;
      if (income > max) max = income;
    }
    return max == 0 ? 1000 : max;
  }

  double _getMaxExpenseValue(Map<String, Map<String, double>> dailyData) {
    double max = 0;
    for (var entry in dailyData.values) {
      final expense = entry['expense'] ?? 0;
      if (expense > max) max = expense;
    }
    return max == 0 ? 1000 : max;
  }
}
