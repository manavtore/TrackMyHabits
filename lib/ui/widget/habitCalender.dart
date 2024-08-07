import 'package:cell_calendar/cell_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_tracker/core/Models/dates.dart';

class HabitCalendar extends StatefulWidget {
  final String userId;

  const HabitCalendar({super.key, required this.userId});

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  late Future<List<CurrentDate>> _futureCurrentDates;

  @override
  void initState() {
    super.initState();
    _futureCurrentDates = fetchCurrentDates();
  }

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CurrentDate>> fetchCurrentDates() async {
    
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('CurrentDates')
          .where('userid', isEqualTo: widget.userId)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No documents found in the collection.');
        return [];
      } else {
        print('Documents found: ${snapshot.docs.length}');
      }

      List<CurrentDate> currentDates = snapshot.docs.map((doc) {
        return CurrentDate.fromMap(doc.data());
      }).toList();

      return currentDates;
    } catch (e) {
      print('Error fetching dates: $e');
      return [];
    }
  }
    Future<void> fetchAndInsertData() async {
    final userid = FirebaseAuth.instance.currentUser?.uid;
    if (userid == null) {
      print('User not logged in');
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('CurrentDates')
          .where('userid', isEqualTo: userid)
          .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      final List<CurrentDate> currentDates = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CurrentDate.fromMap(data);
      }).toList();

      final allScores =
          currentDates.map((date) => date.score.toDouble()).toList();
      final allDates = AllDates(dates: currentDates, allScores: allScores);

      await _firestore.collection('Alldates').doc(userid).set({
        'dates': currentDates.map((date) => date.toMap()).toList(),
        'allScores': allScores,
        'total': allDates.total,
      });

      print('Data inserted successfully');
    } catch (e) {
      print('Failed to fetch or insert data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Calendar"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _futureCurrentDates = fetchCurrentDates();
                  fetchAndInsertData();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CurrentDate>>(
        future: _futureCurrentDates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Available'));
          }

          List<CurrentDate> currentDates = snapshot.data!;

          return CellCalendar(
            events: _buildEvents(currentDates),
            onCellTapped: (date) {
              final eventsOnTheDate = currentDates.where((dateData) {
                final eventDate = DateTime.parse(dateData.date);
                return eventDate.year == date.year &&
                    eventDate.month == date.month &&
                    eventDate.day == date.day;
              }).toList();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('${date.toString().split(' ')[0]}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: eventsOnTheDate.expand((dateData) {
                      return dateData.habitsOfTheDay.map((subHabit) {
                        return Text(
                          '${subHabit.title}: ${subHabit.isComplete ? "Completed" : "Not Completed"}',
                        );
                      }).toList();
                    }).toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            daysOfTheWeekBuilder: (dayIndex) {
              final labels = ["S", "M", "T", "W", "T", "F", "S"];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  labels[dayIndex],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              );
            },
            monthYearLabelBuilder: (datetime) {
              final year = datetime!.year.toString();
              final month = datetime.month.toString();
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  " $month, $year",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<CalendarEvent> _buildEvents(List<CurrentDate> currentDates) {
    List<CalendarEvent> events = [];

    for (var dateData in currentDates) {
      DateTime date = DateTime.parse(dateData.date);
      int habitCount = dateData.habitsOfTheDay.length;

      events.add(CalendarEvent(
        eventName: 'Habits: $habitCount',
        eventDate: date,
        eventTextStyle: const TextStyle(
          fontSize: 10,
          height: 1.5,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return events;
  }
}
