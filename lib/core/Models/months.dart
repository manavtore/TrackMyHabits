// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:habit_tracker/core/Models/dates.dart';

class month {
  late List<CurrentDate> dates;
  late List<double> allScores;
  late String userid;
  late String year;

  month({
    required this.dates,
    required this.allScores,
    required this.userid,
    required this.year,
  });

}

class year {
  late List<month> months;
  late String userid;
  String currentyear;
  year({
    required this.months,
    required this.userid,
    required this.currentyear,
  });
  
}
