// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
var id = FirebaseAuth.instance.currentUser!.uid;

class Habit {
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  int streak;
  bool isComplete;
  int totalCompletions;
  TimeOfDay reminderTime;
  List<Map<DateTime, bool>> days;
  List<String> selectedWeekdays;
  String userid = FirebaseAuth.instance.currentUser!.uid;
  String id;

  Habit({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.streak,
    required this.isComplete,
    required this.totalCompletions,
    required this.reminderTime,
    required this.days,
    required this.selectedWeekdays,
    required this.userid,
    required this.id,
  });

  factory Habit.fromMap(Map<String, dynamic> data) {
    return Habit(
      id: data['id'] ?? '',
      title: data['title'],
      description: data['description'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      streak: data['streak'],
      isComplete: data['isComplete'],
      totalCompletions: data['totalCompletions'],
      reminderTime: TimeOfDay(
        hour: data['reminderTime']['hour'],
        minute: data['reminderTime']['minute'],
      ),
      days: List<Map<DateTime, bool>>.from(data['days']),
      selectedWeekdays: List<String>.from(data['selectedWeekdays']),
      userid: data['userid'], 
    );
  }

  Future<void> addHabit() async {
    try {
      await firestore.collection('Habits').add({
        'title': title,
        'description': description,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'streak': 0,
        'isComplete': false,
        'totalCompletions': totalCompletions,
        'reminderTime': {
          'hour': reminderTime.hour,
          'minute': reminderTime.minute,
        },
        'days': days,
        'selectedWeekdays': selectedWeekdays,
        'userid': userid,
      });
      print('Habit added for user: $userid');
    } catch (e) {
      print('Error adding habit: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'streak': streak,
      'isComplete': isComplete,
      'totalCompletions': totalCompletions,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'days': days,
      'selectedWeekdays': selectedWeekdays,
      'userid': userid,
    };
  }
}
