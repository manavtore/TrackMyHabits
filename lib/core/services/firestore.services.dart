
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FireStoreServices{
  Future<void> addHabit(
      String title, String description, int frequency, DateTime date, TimeOfDay time
  ) async{
    try {
      await firestore.collection('Habits').add({
        'title': title,
        'description': description,
        'frequency': frequency,
        'date': date,
        'time': time,
      });
    } catch (e) {
      print(e);
    }
  }

  static addUser(String uid, String email, String displayName, param3) {}
}