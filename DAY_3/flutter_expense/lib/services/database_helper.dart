import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

/// Service class สำหรับจัดการฐานข้อมูล SQLite
/// ใช้ Singleton pattern เพื่อให้มี instance เดียวตลอด app
/// จัดการ CRUD operations สำหรับ User, Category, Transaction
class DatabaseHelper {
  /// Singleton instance ของ DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();

  /// Database instance (เก็บไว้ในหน่วยความ)
  static Database? _database;

  /// Private constructor สำหรับ Singleton pattern
  DatabaseHelper._init();

  /// Getter สำหรับเข้าถึง database instance
  /// ถ้ายังไม่มี database จะสร้างใหม่ ถ้ามีแล้วจะคืนค่าเดิม
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses_v2.db');
    return _database!;
  }

  /// สร้างและเปิดฐานข้อมูล
  /// [filePath] ชื่อไฟล์ฐานข้อมูล
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // เพิ่ม version เพื่ออัปเกรด schema
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// สร้างโครงสร้างตารางแลมข้อมูลเริ่มต้น
  /// ถูกเรียกเมื่อเปิด app ครั้งแรกเท่านั้น
  Future _createDB(Database db, int version) async {
    // ตารางผู้ใช้งาน
    const userTable = '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      firstName TEXT,
      lastName TEXT,
      nickname TEXT,
      address TEXT,
      phone TEXT,
      email TEXT
    )
    ''';

    const categoryTable = '''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL
    )
    ''';

    const transactionTable = '''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      type TEXT NOT NULL,
      category_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      note TEXT,
      FOREIGN KEY (category_id) REFERENCES categories (id),
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
    ''';

    await db.execute(userTable);
    await db.execute(categoryTable);
    await db.execute(transactionTable);

    // ข้อมูลเริ่มต้น: สร้างหมวดหมู่พื้นฐานให้ผู้ใช้
    await db.insert('categories', {'name': 'เงินเดือน', 'type': 'INCOME'});
    await db.insert('categories', {'name': 'โบนัส', 'type': 'INCOME'});
    await db.insert('categories', {'name': 'ขายของ', 'type': 'INCOME'});
    await db.insert('categories', {'name': 'อาหาร', 'type': 'EXPENSE'});
    await db.insert('categories', {'name': 'เดินทาง', 'type': 'EXPENSE'});
    await db.insert('categories', {'name': 'ค่าเช่า', 'type': 'EXPENSE'});
    await db.insert('categories', {'name': 'ช้อปปิ้ง', 'type': 'EXPENSE'});
    await db.insert('categories', {
      'name': 'บิลค่าน้ำค่าไฟ',
      'type': 'EXPENSE',
    });
  }

  /// อัปเกรดโครงสร้างฐานข้อมูลเมื่อมี version ใหม่
  /// อัปเกรด database จาก version 1 เป็น 2
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // สร้างตารางใหม่
      await db.execute('''
        CREATE TABLE transactions_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL,
          type TEXT NOT NULL,
          category_id INTEGER NOT NULL,
          user_id INTEGER NOT NULL,
          note TEXT,
          FOREIGN KEY (category_id) REFERENCES categories (id),
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');

      // ย้ายข้อมูลเก่า (ถ้ามี) - แปลง category name เป็น id
      final categories = await db.query('categories');
      final categoryMap = {for (var c in categories) c['name']: c['id']};

      final oldTransactions = await db.query('transactions');
      for (var t in oldTransactions) {
        final categoryId = categoryMap[t['category']] ?? 1;
        await db.insert('transactions_new', {
          'id': t['id'],
          'title': t['title'],
          'amount': t['amount'],
          'date': t['date'],
          'type': t['type'],
          'category_id': categoryId,
          'user_id': 1, // default user
          'note': null,
        });
      }

      // ลบตารางเก่าและเปลี่ยนชื่อตารางใหม่
      await db.execute('DROP TABLE transactions');
      await db.execute('ALTER TABLE transactions_new RENAME TO transactions');
    }
  }

  // ========================================
  // User Methods - จัดการข้อมูมผู้ใช้งาน
  // ========================================

  /// ลงทะเบียนผู้ใช้ใหม่
  /// คืนค่า id ของ user ที่สร้างใหม่
  Future<int> registerUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  /// ตรวจสอบการ login ของผู้ใช้
  /// คืนค่า User object ถ้า login สำเร็จ หรือ null ถ้าล้มเหลว
  Future<User?> loginUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  /// ดึงข้อมูล User ด้วย ID (ใช้สำหรับหน้า Profile)
  Future<User?> getUserById(int id) async {
    final db = await instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  /// อัปเดตข้อมูลส่วนตัวของผู้ใช้
  /// คืนค่าจำนวน rows ที่ถูกอัปเดต
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// เปลี่ยนรหัสผ่านของผู้ใช้
  /// คืนค่าจำนวน rows ที่ถูกอัปเดต
  Future<int> changePassword(int userId, String newPassword) async {
    final db = await instance.database;
    return await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ========================================
  // Category Methods - จัดการหมวดหมู่
  // ========================================

  /// เพิ่มหมวดหมู่ใหม่
  /// คืนค่า id ของ category ที่สร้างใหม่
  Future<int> addCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ดึงรายการหมวดหมู่ทั้งหมด
  Future<List<CategoryModel>> getCategories() async {
    final db = await instance.database;
    final result = await db.query('categories');
    return result.map((json) => CategoryModel.fromMap(json)).toList();
  }

  /// แก้ไขข้อมูลหมวดหมู่
  /// คืนค่าจำนวน rows ที่ถูกอัปเดต
  Future<int> updateCategory(CategoryModel category) async {
    final db = await instance.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// ตรวจสอบว่า category มีการใช้งานหรือไม่ (มี transactions ใช้ category นี้หรือไม่)
  /// คืนค่า true ถ้ามีการใช้งาน
  Future<bool> isCategoryInUse(int categoryId) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// ลบหมวดหมู่ (ตรวจสอบก่อนว่ามีการใช้งานหรือไม่)
  /// คืนค่า Map ที่มี success (bool) และ message (String)
  Future<Map<String, dynamic>> deleteCategory(int id) async {
    final db = await instance.database;

    // ตรวจสอบว่ามีการใช้งานหรือไม่
    final inUse = await isCategoryInUse(id);
    if (inUse) {
      return {
        'success': false,
        'message': 'ไม่สามารถลบหมวดหมู่นี้ได้ เนื่องจากมีรายการใช้งานอยู่',
      };
    }

    final rowsDeleted = await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    return {
      'success': rowsDeleted > 0,
      'message': rowsDeleted > 0 ? 'ลบสำเร็จ' : 'ไม่พบหมวดหมู่',
    };
  }

  /// นับจำนวน transactions ที่ใช้ category นี้
  /// คืนค่าจำนวน transactions
  Future<int> getTransactionCountByCategoryId(int categoryId) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE category_id = ?',
      [categoryId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ========================================
  // Transaction Methods - จัดการรายการธุรกรรม
  // ========================================

  /// เพิ่มรายการใหม่
  /// คืนค่า id ของ transaction ที่สร้างใหม่
  Future<int> addTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  /// ดึงรายการ transactions ทั้งหมดหรือของ user คนใดคนหนึ่ง
  /// [userId] ถ้าระบุจะกรองเฉพาะ user นั้น ถ้าไม่ระบุจะดึงทั้งหมด
  Future<List<TransactionModel>> getTransactions({int? userId}) async {
    final db = await instance.database;

    // JOIN กับ categories เพื่อได้ category name มาแสดงผล
    final result = await db.rawQuery('''
      SELECT t.*, c.name as category_name
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      ${userId != null ? 'WHERE t.user_id = ?' : ''}
      ORDER BY t.date DESC, t.id DESC
    ''', userId != null ? [userId] : []);

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  /// แก้ไขข้อมูลรายการ
  /// คืนค่าจำนวน rows ที่ถูกอัปเดต
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// ลบรายการตาม id
  /// คืนค่าจำนวน rows ที่ถูกลบ
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  /// ดึงข้อมูล category ตาม id
  /// คืนค่า CategoryModel หรือ null ถ้าไม่พบ
  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return CategoryModel.fromMap(result.first);
    }
    return null;
  }

  /// ตรวจสอบว่ามี user ในระบบแล้วหรือไม่
  /// ใช้ตรวจสอบก่อนแสดงหน้า Register/Login
  Future<bool> hasAnyUser() async {
    final db = await instance.database;
    final result = await db.query('users', limit: 1);
    return result.isNotEmpty;
  }

  /// ลบบัญชีและข้อมูลทั้งหมด
  /// ใช้สำหรับฟีเจอร์ลบบัญชี
  Future<void> deleteAccountAndAllData() async {
    final db = await instance.database;
    // ลบข้อมูลทั้งหมดตามลำดับ (เพราะมี foreign key constraints)
    await db.delete('transactions');
    await db.delete('categories');
    await db.delete('users');
  }
}
