// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String token;

  User({
    this.id = '',
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user',
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password']?? '',
      role: map['role'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
