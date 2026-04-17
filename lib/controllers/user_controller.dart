import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Tạo user mới trong Firestore sau khi đăng ký
  Future<void> createUser(UserModel user) async {
    await _db.collection("users").doc(user.id).set({
      "name": user.name,
      "email": user.email,
      "ecoPoints": user.ecoPoints,
      "role": user.role,
    });
  }

  /// Lấy user đang đăng nhập
  Future<UserModel?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc =
    await _db.collection("users").doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(user.uid, doc.data() as Map<String, dynamic>);
  }

  /// Lấy user theo ID
  Future<UserModel?> getUserById(String id) async {
    DocumentSnapshot doc =
    await _db.collection("users").doc(id).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(id, doc.data() as Map<String, dynamic>);
  }

  /// Cập nhật bất kỳ field nào của user
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _db.collection("users").doc(id).update(data);
  }

  /// Cập nhật điểm thưởng
  Future<void> updateEcoPoints(String id, int newPoints) async {
    await _db.collection("users").doc(id).update({
      "ecoPoints": newPoints,
    });
  }

  /// Thêm ecoPoints (dùng khi user gửi pin xong)
  Future<void> addEcoPoints(String id, int addPoints) async {
    await _db.collection("users").doc(id).update({
      "ecoPoints": FieldValue.increment(addPoints),
    });
  }

  /// Đổi role user (admin / collector / user)
  Future<void> updateRole(String id, String newRole) async {
    await _db.collection("users").doc(id).update({
      "role": newRole,
    });
  }
}