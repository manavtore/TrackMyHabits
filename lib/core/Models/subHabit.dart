import 'dart:convert';

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
}
