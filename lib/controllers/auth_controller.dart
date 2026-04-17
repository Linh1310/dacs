import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Đăng ký bằng email
  Future<String?> register(String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        "createdAt": DateTime.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Đăng nhập bằng email
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 🔥 ĐĂNG NHẬP GOOGLE
  Future<String?> loginWithGoogle() async {
    try {
      // B1: Mở Google chọn tài khoản
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return "Đã hủy đăng nhập Google";
      }

      // B2: Lấy token
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // B3: Tạo credential cho Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // B4: Đăng nhập vào Firebase
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      // B5: Lưu user vào Firestore nếu lần đầu
      if (user != null) {
        DocumentSnapshot snapshot =
        await _db.collection("users").doc(user.uid).get();

        if (!snapshot.exists) {
          await _db.collection("users").doc(user.uid).set({
            "name": user.displayName,
            "email": user.email,
            "avatar": user.photoURL,
            "createdAt": DateTime.now(),
          });
        }
      }

      return null; // thành công
    } catch (e) {
      return e.toString();
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;
}