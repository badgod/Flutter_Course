# เก็บ Class ของ uCrop (image_cropper) ไว้
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }

# แก้ปัญหาหา OkHttp ไม่เจอ (ที่ uCrop เรียกใช้)
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-dontwarn okio.**