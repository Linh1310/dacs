import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart'; 
import 'views/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EcoBatApp());
}

class EcoBatApp extends StatelessWidget {
  const EcoBatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoBat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E8B57),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Bạn có thể chọn hiện LoginPage hoặc EcoBatHomeScreen tùy ý ở đây
      home: const LoginPage(), 
    );
  }
}