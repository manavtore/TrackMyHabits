// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';

import 'package:habit_tracker/core/Models/subHabit.dart';


class CurrentDate {
  List<SubHabit> habitsOfTheDay;
  int score;
  String date;
  String userid;

  CurrentDate({
    required this.habitsOfTheDay,
    this.score = 0,
    required this.date,
    String? userid,
  }) : userid = userid ?? FirebaseAuth.instance.currentUser!.uid;

  void calculateScore() {
    score = 0;

    for (var habit in habitsOfTheDay) {
      if (habit.isComplete) {
        score += 1;
      }
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'habitsOfTheDay': habitsOfTheDay.map((habit) => habit.toMap()).toList(),
      'score': score,
      'date': date,
      'userid': userid,
    };
  }

  int getScore() {
    return score;
  }

  factory CurrentDate.fromMap(Map<String, dynamic> map) {
    return CurrentDate(
      habitsOfTheDay: (map['habitsOfTheDay'] as List<dynamic>)
          .map((item) => SubHabit.fromMap(item as Map<String, dynamic>))
          .toList(),
      score: map['score'] as int,
      date: map['date'] as String,
      userid: map['userid'] as String,
    );
  }
}

class AllDates {
  List<CurrentDate> dates;
  List<double> allScores;
  String userid;

  AllDates({
    required this.dates,
    required this.allScores,
    String? userid,
  }) : userid = userid ?? FirebaseAuth.instance.currentUser!.uid;

  double get total => allScores.fold(0, (prev, element) => prev + element);
}
