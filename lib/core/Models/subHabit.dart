import 'dart:convert';

import 'package:habit_tracker/core/Models/habit.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class SubHabit {
  String title;
  String habitid;
  bool isComplete;

  SubHabit({
    required this.title,
    required this.habitid,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'habitid': habitid,
      'isComplete': isComplete,
    };
  }

  factory SubHabit.fromMap(Map<String, dynamic> map) {
    return SubHabit(
      title: map['title'] as String,
      habitid: map['habitid'] as String,
      isComplete: map['isComplete'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubHabit.fromJson(String source) =>
      SubHabit.fromMap(json.decode(source) as Map<String, dynamic>);


  SubHabit copyWith({
    String? title,
    String? habitid,
    bool? isComplete,
  }) {
    return SubHabit(
      title: title ?? this.title,
      habitid: habitid ?? this.habitid,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  String toString() => 'SubHabit(title: $title, habitid: $habitid, isComplete: $isComplete)';

  @override
  bool operator ==(covariant SubHabit other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.habitid == habitid &&
      other.isComplete == isComplete;
  }

  @override
  int get hashCode => title.hashCode ^ habitid.hashCode ^ isComplete.hashCode;

  static fromHabit(Habit habit) {}
}
