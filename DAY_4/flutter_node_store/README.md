# 🛒 Flutter Node Store

แอปพลิเคชันร้านค้าออนไลน์ที่พัฒนาด้วย Flutter และ Node.js เป็น Backend API สำหรับการจัดการสินค้า (CRUD) พร้อมระบบ Authentication และการจัดการรูปภาพ

## 📱 ฟีเจอร์หลัก

- ✅ **หน้า Welcome & Introduction** - แสดงหน้าต้อนรับเมื่อเปิดแอปครั้งแรก
- 🔐 **ระบบ Authentication** - ลงทะเบียน, เข้าสู่ระบบ, และลืมรหัสผ่าน
- 🏠 **Dashboard** - แสดงรายการสินค้าทั้งหมด
- ➕ **เพิ่มสินค้า** - เพิ่มสินค้าใหม่พร้อมรูปภาพ
- ✏️ **แก้ไขสินค้า** - อัปเดตข้อมูลสินค้าที่มีอยู่
- 🗑️ **ลบสินค้า** - ลบสินค้าออกจากระบบ
- 📸 **จัดการรูปภาพ** - ถ่ายภาพหรือเลือกจากแกลเลอรี่ พร้อมฟีเจอร์ครอปรูป
- 🎨 **UI/UX สวยงาม** - ออกแบบด้วย Material Design

## 🛠️ เทคโนโลยีที่ใช้

### Frontend (Flutter)
- **Flutter SDK** - Framework สำหรับพัฒนา Mobile App
- **Dio** - HTTP Client สำหรับเรียก API
- **Shared Preferences** - เก็บข้อมูลในเครื่อง (Token, User Info)
- **Image Picker** - เลือกรูปภาพจากกล้องหรือแกลเลอรี่
- **Image Cropper** - ครอปและแก้ไขรูปภาพ
- **Introduction Screen** - หน้า Onboarding
- **Logger** - แสดง Log สำหรับ Debug
- **Connectivity Plus** - ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต

### Backend
- **Node.js** + **Express.js** - REST API Server
- **MySQL** - ฐานข้อมูล

## 📋 ข้อกำหนดเบื้องต้น

ก่อนเริ่มต้น ตรวจสอบให้แน่ใจว่าคุณได้ติดตั้งสิ่งต่อไปนี้แล้ว:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (เวอร์ชัน 3.10.3 ขึ้นไป)
- [Dart SDK](https://dart.dev/get-dart) (มากับ Flutter)
- [Android Studio](https://developer.android.com/studio) หรือ [Xcode](https://developer.apple.com/xcode/) (สำหรับ iOS)
- [Node.js](https://nodejs.org/) (สำหรับ Backend Server)
- [Visual Studio Code](https://code.visualstudio.com/) พร้อม Flutter Extension

---

## 🏗️ ขั้นตอนการสร้างโปรเจคตั้งแต่ต้น (Step by Step)

### **STEP 1: สร้างโปรเจค Flutter**

เปิด Terminal หรือ Command Prompt แล้วรันคำสั่ง:

```bash
# สร้างโปรเจคใหม่
flutter create flutter_node_store

# เข้าไปในโฟลเดอร์โปรเจค
cd flutter_node_store

# เปิดใน VS Code
code .
```

### **STEP 2: ติดตั้ง Dependencies**

แก้ไขไฟล์ `pubspec.yaml` เพิ่ม dependencies ที่ต้องใช้:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  introduction_screen: ^4.0.0      # หน้า Onboarding
  shared_preferences: ^2.5.4       # เก็บข้อมูลในเครื่อง
  logger: ^2.6.2                   # แสดง Log
  connectivity_plus: ^7.0.0        # ตรวจสอบอินเทอร์เน็ต
  dio: ^5.9.0                      # HTTP Client
  http_parser: ^4.1.2              # Parse HTTP Headers
  image_picker: ^1.2.1             # เลือกรูปภาพ
  image_cropper: ^11.0.0           # ครอปรูปภาพ
```

บันทึกไฟล์แล้วรันคำสั่ง:

```bash
flutter pub get
```

### **STEP 3: สร้างโครงสร้างโฟลเดอร์**

สร้างโฟลเดอร์ภายใน `lib/`:

```bash
# สร้างโฟลเดอร์ด้วยคำสั่ง (macOS/Linux)
mkdir -p lib/components
mkdir -p lib/models
mkdir -p lib/screens/welcome
mkdir -p lib/screens/login
mkdir -p lib/screens/register
mkdir -p lib/screens/forgotpassword
mkdir -p lib/screens/dashboard
mkdir -p lib/screens/bottomnavpage
mkdir -p lib/screens/drawerpage
mkdir -p lib/screens/products/components
mkdir -p lib/services
mkdir -p lib/themes
mkdir -p lib/utils

# หรือสร้างด้วย Windows Command Prompt
# mkdir lib\components lib\models lib\screens lib\services lib\themes lib\utils
```

### **STEP 4: สร้างไฟล์ Constants**

สร้างไฟล์ `lib/utils/constants.dart`:

```dart
// API URL
// สำหรับ Android Emulator
const baseURLAPI = 'http://10.0.2.2:3000/api/';
const baseURLImage = 'http://10.0.2.2:3000/uploads/images/';

// สำหรับเครื่องจริง (ใช้ IP ของเครื่องคุณ)
// const baseURLAPI = 'http://192.168.x.x:3000/api/';
// const baseURLImage = 'http://192.168.x.x:3000/uploads/images/';
```

### **STEP 5: สร้าง Utility Class**

สร้างไฟล์ `lib/utils/utility.dart`:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Utility {
  // Logger Instance
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 75,
      colors: true,
      printEmojis: true,
    ),
  );

  // ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
  static Future<String> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return '';
    }
    return 'online';
  }

  // แสดง Alert Dialog
  static void showAlertDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.pop(context),
            child: const Text('ตรงลง'),
          ),
        ],
      ),
    );
  }
}
```

### **STEP 6: ตั้งค่า Dio Client**

สร้างไฟล์ `lib/services/dio_config.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_node_store/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConfig {
  // Dio ไม่มี Token
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseURLAPI,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Dio มี Token (สำหรับ API ที่ต้อง Authentication)
  static final Dio dioWithAuth = Dio(
    BaseOptions(
      baseUrl: baseURLAPI,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
}
```

### **STEP 7: สร้าง Product Model**

สร้างไฟล์ `lib/models/product_model.dart`:

```dart
import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  int? id;
  String? name;
  String? description;
  String? barcode;
  int? stock;
  double? price;
  int? categoryId;
  int? userId;
  int? statusId;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.barcode,
    this.stock,
    this.price,
    this.categoryId,
    this.userId,
    this.statusId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        barcode: json["barcode"],
        stock: json["stock"],
        price: json["price"]?.toDouble(),
        categoryId: json["category_id"],
        userId: json["user_id"],
        statusId: json["status_id"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "barcode": barcode,
        "stock": stock,
        "price": price,
        "category_id": categoryId,
        "user_id": userId,
        "status_id": statusId,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
```

### **STEP 8: สร้าง REST API Service**

สร้างไฟล์ `lib/services/rest_api.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_node_store/models/product_model.dart';
import 'package:flutter_node_store/services/dio_config.dart';
import 'package:flutter_node_store/utils/utility.dart';
import 'package:http_parser/http_parser.dart';

class CallAPI {
  final Dio _dio = DioConfig.dio;
  final Dio _dioWithAuth = DioConfig.dioWithAuth;

  // Register API
  registerAPI(data) async {
    try {
      final response = await _dio.post('auth/register', data: data);
      Utility().logger.d(response.data);
      return jsonEncode(response.data);
    } catch (e) {
      Utility().logger.e(e);
      return jsonEncode({'message': 'Error: $e'});
    }
  }

  // Login API
  loginAPI(data) async {
    try {
      final response = await _dio.post('auth/login', data: data);
      Utility().logger.d(response.data);
      return jsonEncode(response.data);
    } catch (e) {
      Utility().logger.e(e);
      return jsonEncode({'message': 'Error: $e'});
    }
  }

  // Get All Products
  Future<List<ProductModel>> getAllProducts() async {
    final response = await _dioWithAuth.get('products');
    if (response.statusCode == 200) {
      Utility().logger.d(response.data);
      final List<ProductModel> products = productModelFromJson(
        json.encode(response.data),
      );
      return products;
    }
    return [];
  }

  // Create Product
  Future<bool> createProduct(Map<String, dynamic> data, File? imageFile) async {
    try {
      FormData formData = FormData.fromMap(data);
      
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await _dioWithAuth.post('products', data: formData);
      Utility().logger.d(response.data);
      return response.statusCode == 201;
    } catch (e) {
      Utility().logger.e(e);
      return false;
    }
  }

  // Update Product
  Future<bool> updateProduct(
    int id,
    Map<String, dynamic> data,
    File? imageFile,
  ) async {
    try {
      FormData formData = FormData.fromMap(data);
      
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

      final response = await _dioWithAuth.put('products/$id', data: formData);
      Utility().logger.d(response.data);
      return response.statusCode == 200;
    } catch (e) {
      Utility().logger.e(e);
      return false;
    }
  }

  // Delete Product
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dioWithAuth.delete('products/$id');
      Utility().logger.d(response.data);
      return response.statusCode == 200;
    } catch (e) {
      Utility().logger.e(e);
      return false;
    }
  }
}
```

### **STEP 9: ตั้งค่า Android Permissions**

แก้ไขไฟล์ `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.CAMERA"/> 
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application
        android:label="Flutter Store"
        android:name="${applicationName}"
        android:usesCleartextTraffic="true"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme" />
              
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <!-- UCrop Activity สำหรับ image_cropper -->
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
```

### **STEP 10: ตั้งค่า iOS Permissions**

แก้ไขไฟล์ `ios/Runner/Info.plist` เพิ่มก่อน `</dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>ต้องการใช้กล้องเพื่อถ่ายภาพสินค้า</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>ต้องการเข้าถึงคลังภาพเพื่อเลือกรูปภาพสินค้า</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>ต้องการบันทึกรูปภาพลงในคลังภาพ</string>
```

### **STEP 11: สร้าง App Router**

สร้างไฟล์ `lib/app_router.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_node_store/screens/welcome/welcome_screen.dart';
import 'package:flutter_node_store/screens/login/login_screen.dart';
import 'package:flutter_node_store/screens/register/register_screen.dart';
import 'package:flutter_node_store/screens/bottomnavpage/home_screen.dart';
import 'package:flutter_node_store/screens/products/product_add.dart';
import 'package:flutter_node_store/screens/products/product_update.dart';

class AppRouter {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productAdd = '/product/add';
  static const String productUpdate = '/product/update';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case productAdd:
        return MaterialPageRoute(builder: (_) => const ProductAdd());
      case productUpdate:
        return MaterialPageRoute(
          builder: (_) => const ProductUpdate(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
```

### **STEP 12: แก้ไข main.dart**

แก้ไขไฟล์ `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_node_store/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ตรวจสอบว่าเคยเปิดแอปหรือยัง
  final prefs = await SharedPreferences.getInstance();
  final hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;
  final token = prefs.getString('token');
  
  String initialRoute = AppRouter.welcome;
  if (hasSeenWelcome) {
    initialRoute = token != null ? AppRouter.home : AppRouter.login;
  }
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
```

### **STEP 13: สร้างหน้าจอต่างๆ**

ตอนนี้คุณต้องสร้างหน้าจอต่างๆ ตามโครงสร้างที่กำหนด:

1. **Welcome Screen** - หน้าต้อนรับ
2. **Login Screen** - หน้าเข้าสู่ระบบ
3. **Register Screen** - หน้าลงทะเบียน
4. **Home Screen** - หน้าหลัก (Dashboard)
5. **Product Add/Update** - หน้าเพิ่ม/แก้ไขสินค้า

### **STEP 14: ทดสอบรันแอป**

```bash
# ตรวจสอบว่าไม่มี error
flutter analyze

# รันแอป
flutter run
```

### **STEP 15: เตรียม Backend API**

ตรวจสอบว่า Backend Node.js Server รันอยู่และมี endpoints:

- `POST /api/auth/register` - ลงทะเบียน
- `POST /api/auth/login` - เข้าสู่ระบบ
- `GET /api/products` - ดึงรายการสินค้า
- `POST /api/products` - เพิ่มสินค้า
- `PUT /api/products/:id` - แก้ไขสินค้า
- `DELETE /api/products/:id` - ลบสินค้า

---

## 🚀 ขั้นตอนการติดตั้งและรันโปรเจค

### **ขั้นตอนที่ 1: Clone โปรเจค**

```bash
git clone https://github.com/your-username/flutter_node_store.git
cd flutter_node_store
```

### **ขั้นตอนที่ 2: ติดตั้ง Dependencies**

```bash
flutter pub get
```

คำสั่งนี้จะดาวน์โหลด packages ทั้งหมดที่ระบุใน `pubspec.yaml`

### **ขั้นตอนที่ 3: ตั้งค่า Backend Server**

#### 3.1 เตรียม Node.js Server

ให้แน่ใจว่า Backend Server (Node.js + Express) รันอยู่ที่ `http://localhost:3000`

```bash
cd /path/to/your/backend
npm install
npm start
```

#### 3.2 กำหนด URL ของ API

แก้ไขไฟล์ `lib/utils/constants.dart`:

```dart
// สำหรับ Android Emulator
const baseURLAPI = 'http://10.0.2.2:3000/api/';
const baseURLImage = 'http://10.0.2.2:3000/uploads/images/';

// สำหรับเครื่องจริง (ต้องอยู่ WiFi เดียวกัน)
// const baseURLAPI = 'http://192.168.x.x:3000/api/';
// const baseURLImage = 'http://192.168.x.x:3000/uploads/images/';

// สำหรับ Server จริง
// const baseURLAPI = 'https://your-api.com/api/';
// const baseURLImage = 'https://your-api.com/uploads/images/';
```

**หมายเหตุ:**
- `10.0.2.2` - IP พิเศษสำหรับ Android Emulator เพื่ออ้างถึงเครื่อง host
- `192.168.x.x` - IP ในเครือข่ายท้องถิ่น (หาได้จาก `ipconfig` บน Windows หรือ `ifconfig` บน Mac/Linux)
- สำหรับ iOS Simulator ใช้ `http://localhost:3000` ได้เลย

### **ขั้นตอนที่ 4: ตรวจสอบ Android Configuration**

ตรวจสอบ `android/app/src/main/AndroidManifest.xml` ว่ามี permissions และ activities ครบถ้วน:

```xml
<uses-permission android:name="android.permission.CAMERA"/> 
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
<uses-permission android:name="android.permission.INTERNET"/>

<!-- UCrop Activity สำหรับ image_cropper -->
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

### **ขั้นตอนที่ 5: รันแอปพลิเคชัน**

#### เลือกอุปกรณ์ที่ต้องการรัน

```bash
# ดูรายการอุปกรณ์ที่เชื่อมต่อ
flutter devices

# รันบน Android Emulator
flutter run

# รันบนเครื่องจริง (ระบุ device id)
flutter run -d <device-id>
```

#### Hot Reload & Hot Restart

- กด `r` = Hot Reload (รีโหลดเฉพาะส่วนที่เปลี่ยนแปลง)
- กด `R` = Hot Restart (รีสตาร์ททั้งแอป)
- กด `q` = ปิดแอป

### **ขั้นตอนที่ 6: ทดสอบแอป**

1. **Welcome Screen** - เปิดแอปครั้งแรกจะเห็นหน้า Introduction
2. **Login** - ลงทะเบียนหรือเข้าสู่ระบบ
3. **Dashboard** - ดูรายการสินค้า
4. **เพิ่มสินค้า** - กดปุ่ม `+` เพื่อเพิ่มสินค้าใหม่
5. **แก้ไข/ลบ** - กดที่สินค้าเพื่อแก้ไขหรือลบ

## 📁 โครงสร้างโปรเจค

```
lib/
├── main.dart                 # จุดเริ่มต้นของแอป
├── app_router.dart           # กำหนด Routes ทั้งหมด
├── components/               # Widget ที่ใช้ซ้ำ
├── models/                   # Data Models
│   └── product_model.dart
├── screens/                  # หน้าจอต่างๆ
│   ├── welcome/              # หน้า Welcome & Introduction
│   ├── login/                # หน้าเข้าสู่ระบบ
│   ├── register/             # หน้าลงทะเบียน
│   ├── forgotpassword/       # หน้าลืมรหัสผ่าน
│   ├── dashboard/            # หน้าแดชบอร์ด
│   ├── bottomnavpage/        # หน้า Bottom Navigation
│   ├── drawerpage/           # หน้า Drawer Menu
│   └── products/             # หน้าจัดการสินค้า (CRUD)
│       ├── product_add.dart
│       ├── product_update.dart
│       └── components/
│           ├── product_form.dart
│           └── product_image.dart
├── services/                 # API Services
│   ├── dio_config.dart       # ตั้งค่า Dio Client
│   └── rest_api.dart         # API Endpoints
├── themes/                   # Theme & Styles
└── utils/                    # Utilities
    ├── constants.dart        # ค่าคงที่ (API URLs)
    └── utility.dart          # ฟังก์ชันช่วยเหลือ
```

## 🔧 การแก้ปัญหาที่พบบ่อย

### 1. **แอปไม่สามารถเชื่อมต่อ API**

**วิธีแก้:**
- ตรวจสอบว่า Backend Server รันอยู่หรือไม่
- ตรวจสอบ URL ใน `lib/utils/constants.dart`
- สำหรับ Android Emulator ใช้ `10.0.2.2` แทน `localhost`
- ตรวจสอบว่ามี Internet Permission ใน `AndroidManifest.xml`

### 2. **แอปปิดตัวเองเมื่อเลือกรูป**

**วิธีแก้:**
- ตรวจสอบว่ามี UCropActivity ใน `AndroidManifest.xml`
- ตรวจสอบ Permissions สำหรับกล้องและแกลเลอรี่

### 3. **รูปภาพไม่แสดงในหน้า Update**

**วิธีแก้:**
- ตรวจสอบว่า `baseURLImage` ใน constants ถูกต้อง
- ตรวจสอบว่ารูปอยู่ใน Backend Server จริง

### 4. **Build Error บน Android**

```bash
# ลบ cache และ build ใหม่
flutter clean
flutter pub get
flutter run
```

## 📱 Screenshots

*(เพิ่มภาพหน้าจอของแอปของคุณที่นี่)*

## 🤝 การพัฒนาต่อยอด

แนวทางในการพัฒนาเพิ่มเติม:

- 🔍 เพิ่มระบบค้นหาสินค้า
- 🛒 เพิ่มระบบตะกร้าสินค้า
- 💳 เพิ่มระบบชำระเงิน
- 👤 เพิ่มหน้าโปรไฟล์ผู้ใช้
- 🌐 รองรับหลายภาษา (Localization)
- 🌙 เพิ่ม Dark Mode
- 📊 เพิ่มหน้ารายงานสถิติ

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

## 👨‍💻 ผู้พัฒนา

สร้างโดย **Supod Wongsri**

---

**หมายเหตุ:** โปรเจคนี้สร้างขึ้นเพื่อการศึกษาและฝึกฝนการใช้ Flutter ในการพัฒนา Mobile Application แบบ Full Stack
