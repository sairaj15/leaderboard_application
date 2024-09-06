class UserModel {
  UserModel({
    required this.points,
    required this.isAdmin,
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
  final int points;
  final bool isAdmin;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'points': points,
      'isAdmin': isAdmin,
    };
  }

  factory UserModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] != null ? map['email'] as String : '',
      points: map['points'] ?? 0,
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
