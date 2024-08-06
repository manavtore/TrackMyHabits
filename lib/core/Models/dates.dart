import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';

class CurrentDate {
  List<Map<String, bool>> habitsOfTheDay;
  int score;
  String date; 
  String userid = FirebaseAuth.instance.currentUser!.uid;


  CurrentDate({
    required this.habitsOfTheDay,
    required this.score,
    required this.date, 
  });

  void calculateScore(int totalHabits) {
    int completedCount =
        habitsOfTheDay.where((habit) => habit.values.first).length;
    score = ((completedCount / totalHabits) * 10).toInt();
  }

  Map<String, dynamic> toMap() {
    return {
      'habitsOfTheDay': habitsOfTheDay,
      'score': score,
      'date': date,
      'userid': userid,
    };
  }

  factory CurrentDate.fromMap(Map<String, dynamic> data) {
    return CurrentDate(
      habitsOfTheDay: List<Map<String, bool>>.from(data['habitsOfTheDay']),
      score: data['score'],
      date: data['date'],
    );
  }
}


class AllDates {
  List<CurrentDate> dates;
  List<double> allScores;
  String userid = FirebaseAuth.instance.currentUser!.uid;

  AllDates({
    required this.dates,
    required this.allScores,
  });

  double get total => allScores.fold(0, (prev, element) => prev + element);
}
