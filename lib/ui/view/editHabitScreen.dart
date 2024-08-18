// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/Models/habit.dart';
import 'package:habit_tracker/core/utils/weekdays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class editHabit extends StatefulWidget {
  final String habitId;

  const editHabit({super.key, required this.habitId});

  @override
  State<editHabit> createState() => _editHabitState();
}

class _editHabitState extends State<editHabit> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  TextEditingController habitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime startDateController = DateTime.now();
  DateTime endDateController = DateTime.now().add(const Duration(days: 1));
  TimeOfDay reminderTimeController = TimeOfDay.now();
  bool isCompleteController = false;
  List<Map<DateTime, bool>> daysController = [];
  List<String> selectedWeekdays = [];

  @override
  void initState() {
    super.initState();
    _loadHabitData();
  }

  Future<void> _loadHabitData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('habits').doc(widget.habitId).get();
      if (doc.exists) {
        Habit habit = Habit.fromMap(doc.data() as Map<String, dynamic>);
        setState(() {
          habitNameController.text = habit.title;
          descriptionController.text = habit.description;
          startDateController = habit.startDate;
          endDateController = habit.endDate;
          reminderTimeController = habit.reminderTime;
          selectedWeekdays = habit.selectedWeekdays;
          daysController = habit.days;
        });
      } else {
        print('Habit not found');
      }
    } catch (e) {
      print('Error loading habit data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Habit"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              updateHabit();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextField(
            controller: habitNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Habit Name',
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: startDateController,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  startDateController = selectedDate;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start Date',
              ),
              child: Text(
                '${startDateController.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: endDateController,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  endDateController = selectedDate;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'End Date',
              ),
              child: Text(
                '${endDateController.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: reminderTimeController,
              );
              if (selectedTime != null) {
                setState(() {
                  reminderTimeController = selectedTime;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Reminder Time',
              ),
              child: Text(
                reminderTimeController.format(context),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 10.0,
            runSpacing: 5.0,
            children: weekdays.map((day) {
              return FilterChip(
                label: Text(day),
                selected: selectedWeekdays.contains(day),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      selectedWeekdays.add(day);
                    } else {
                      selectedWeekdays.remove(day);
                    }
                  });
                  print("Selected Weekdays: $selectedWeekdays");
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  void updateHabit() async {
    Habit updatedHabit = Habit(
      id: widget.habitId,
      title: habitNameController.text,
      description: descriptionController.text,
      startDate: startDateController,
      endDate: endDateController,
      streak: 0,
      isComplete: false,
      totalCompletions: 0,
      reminderTime: reminderTimeController,
      days: daysController,
      selectedWeekdays: selectedWeekdays,
      userid: FirebaseAuth.instance.currentUser!.uid,
    );

    try {
      await _firestore
          .collection('habits')
          .doc(widget.habitId)
          .update(updatedHabit.toMap());
      print('Habit updated successfully');

      DateTime now = DateTime.now();
      DateTime scheduledDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminderTimeController.hour,
        reminderTimeController.minute,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Habit updated and notification rescheduled successfully!')),
      );

      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print('Error updating habit: $e');
    }
  }

 
}
