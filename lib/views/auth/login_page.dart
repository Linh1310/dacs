import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: InputDecoration(labelText: "Mật khẩu"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? error = await auth.login(email.text, password.text);

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng nhập thành công")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: Text("Đăng nhập"),
            ),
            ElevatedButton(
              child: Text("Đăng nhập với Google"),
              onPressed: () async {
                final result = await AuthController().loginWithGoogle();
                if (result == null) {
                  print("Đăng nhập Google thành công!");
                } else {
                  print("Lỗi: $result");
                }
              },
            ),
            ElevatedButton(
              child: Text("Test Firestore"),
              onPressed: () async {
                final result = await AuthController().testFirestoreConnection();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result ?? "Lỗi không xác định")));
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Chưa có tài khoản? Đăng ký"),
            )

          ],
        ),
      ),
    );
  }
}