class UserModel {
  final String email;
  final String? username;
  final String? id;

  const UserModel({
    this.id,
    required this.email,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        username: json['username'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'username': username,
        'id': id,
      };
}
