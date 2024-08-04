import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final Timestamp joinedDate;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.joinedDate,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['displayName'] ?? '',
      joinedDate: data['joinedDate'] ?? Timestamp.now(),
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
