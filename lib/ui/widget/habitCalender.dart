import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/utils.dart';
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

Future<List<CurrentDate>> fetchCurrentDates() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('Alldates').get();
      if (snapshot.docs.isEmpty) {
        print('No documents found in the collection.');
        return [];
      } else {
        print('Documents found: ${snapshot.docs.length}');
      }

      var doc = snapshot.docs.first.data();

      List<dynamic> datesData = doc['dates'] ?? [];
      print('Dates data: $datesData');

      List<CurrentDate> currentDates = datesData.map((data) {
        print('Date data: $data');
        return CurrentDate.fromMap(data as Map<String, dynamic>);
      }).toList();

      return currentDates;
    } catch (e) {
      print('Error fetching dates: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Calendar"),
        centerTitle: false,
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
                      return dateData.habitsOfTheDay.map((habit) {
                        String habitName = habit.keys.first;
                        bool isComplete = habit.values.first;
                        return Text(
                            '$habitName: ${isComplete ? "Completed" : "Not Completed"}');
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
                  style: const TextStyle(fontSize: 20, 
                  fontWeight: FontWeight.bold),
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
          color: Colors.white),
      ));
    }

    return events;
  }
}
