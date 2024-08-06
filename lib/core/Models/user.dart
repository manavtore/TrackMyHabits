// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final Timestamp joinedDate;
  final String habitid;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.joinedDate,
    required this.habitid,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['displayName'] ?? '',
      joinedDate: data['joinedDate'] ?? Timestamp.now(), habitid: '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': username,
      'joinedDate': joinedDate,
    };
  }
}
