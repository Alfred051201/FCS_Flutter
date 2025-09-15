// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TFeedback {

  final String? id;
  final String userId;
  final String name;
  final String email;
  final String category;
  final String message;
  final String status;
  final DateTime? startResolve;
  final DateTime? finishResolve;
  final double? userRating;
  final String? updateComment;
  final List<String>? updateImages;
  final DateTime createdAt;

  TFeedback({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.category,
    required this.message,
    required this.status,
    this.startResolve,
    this.finishResolve,
    this.userRating,
    this.updateComment,
    this.updateImages,
    required this.createdAt,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'category': category,
      'message': message,
      'status': status,
      'startResolve': startResolve?.millisecondsSinceEpoch,
      'finishResolve': finishResolve?.millisecondsSinceEpoch,
      'userRating': userRating,
      'updateComment': updateComment,
      'updateImages': updateImages,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TFeedback.fromMap(Map<String, dynamic> map) {
    return TFeedback(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      category: map['category'] ?? '',
      message: map['message'] ?? '',
      status: map['status'] ?? '',
      startResolve: map['startResolve'] != null ? DateTime.parse(map['startResolve']) : null,
      finishResolve: map['finishResolve'] != null ? DateTime.parse(map['finishResolve']) : null,
      userRating: map['userRating']?.toDouble() ?? 0.0,
      updateComment: map['updateComment'] ?? '',
      updateImages: List<String>.from(map['updateImages']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TFeedback.fromJson(String source) => TFeedback.fromMap(json.decode(source) as Map<String, dynamic>);
}
