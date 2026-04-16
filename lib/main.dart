import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import file bạn vừa tạo

void main() {
  runApp(const EcoBatApp());
}

class EcoBatApp extends StatelessWidget {
  const EcoBatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoBat',
      debugShowCheckedModeBanner: false, // Ẩn cái chữ "DEBUG" xấu xí góc phải
      theme: ThemeData(
        primaryColor: const Color(0xFF2E8B57), // Màu SeaGreen
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const EcoBatHomeScreen(), // Gọi màn hình Trang chủ ra
    );
  }
}