// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TNotification {
  final String? id;
  final String from;
  final String to;
  final String feedbackId;
  final String type;
  final bool read;
  final DateTime createdAt;

  TNotification({
    required this.id, 
    required this.from, 
    required this.to, 
    required this.feedbackId, 
    required this.type, 
    required this.read, 
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'from': from,
      'to': to,
      'feedbackId': feedbackId,
      'type': type,
      'read': read,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TNotification.fromMap(Map<String, dynamic> map) {
    return TNotification(
      id: map['_id'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      feedbackId: map['feedbackId']["_id"],
      type: map['type'] ?? '',
      read: map['read'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TNotification.fromJson(String source) => TNotification.fromMap(json.decode(source) as Map<String, dynamic>);
}
