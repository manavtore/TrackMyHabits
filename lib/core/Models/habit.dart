import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> days;
  final TimeOfDay reminderTime;
  bool isCompleted;
  int streak;
  int totalCompletions;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.reminderTime,
    this.isCompleted = false,
    this.streak = 0,
    this.totalCompletions = 0,
  });

  factory Habit.fromMap(Map<String, dynamic> data, String documentId) {
    return Habit(
      id: documentId,
      title: data['title'],
      description: data['description'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      days: List<int>.from(data['days']),
      reminderTime: TimeOfDay(
        hour: data['reminderTime']['hour'],
        minute: data['reminderTime']['minute'],
      ),
      isCompleted: data['isCompleted'],
      streak: data['streak'],
      totalCompletions: data['totalCompletions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'days': days,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'isCompleted': isCompleted,
      'streak': streak,
      'totalCompletions': totalCompletions,
    };
  }
}

