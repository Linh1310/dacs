class UserModel {
  String id;
  String name;
  String email;
  int ecoPoints;
  String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.ecoPoints,
    required this.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      ecoPoints: data['ecoPoints'],
      role: data['role'],
    );
  }
}