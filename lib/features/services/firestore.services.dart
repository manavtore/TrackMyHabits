
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirestoreServices {
  Future<void> addHabit(String title, String description, int frequency, DateTime date, TimeOfDay time) async {
    try {
      await firestore.collection('Habits').add({
        'title': title,
        'description': description,
        'frequency': frequency,
        'date': date,
        'time': time,
      });
    } catch (e) {
      print('Error adding habit: $e');
    }
  }

  // Function to add a new user to the Firestore
  Future<void> addUser(String id, String email, String displayName, DateTime date) async {
    try {
      await firestore.collection('User').doc(id).set({
        'email': email,
        'displayName': displayName,
        'joinedDate': date,
      });
    } catch (e) {
      print('Error registering user: $e');
    }
  }
  
}
