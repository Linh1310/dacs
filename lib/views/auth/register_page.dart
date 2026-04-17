import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: "Tên")),
            TextField(controller: email, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: InputDecoration(labelText: "Mật khẩu"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? error = await auth.register(
                  email.text,
                  password.text,
                  name.text,
                );

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng ký thành công")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: Text("Đăng ký"),
            ),
          ],
        ),
      ),
    );
  }
}