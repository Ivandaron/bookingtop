class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // "admin" ou "agence" ou "client"

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
