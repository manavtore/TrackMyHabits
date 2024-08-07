import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/Models/habit.dart';
import 'package:habit_tracker/core/services/firestore.services.dart';
import 'package:habit_tracker/core/utils/weekdays.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:habit_tracker/features/notification/notification.service.dart';
import 'package:habit_tracker/ui/view/homeScreen.dart';
class NewHabit extends StatefulWidget {
  const NewHabit({super.key});

  @override
  State<NewHabit> createState() => _NewHabitState();
}

class _NewHabitState extends State<NewHabit> {
  TextEditingController habitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  DateTime startDateController = DateTime.now();
  DateTime endDateController = DateTime.now().add(const Duration(days: 1));
  TimeOfDay reminderTimeController = TimeOfDay.now();
  bool isCompleteController = false;
  List<Map<DateTime, bool>> daysController = [];
  List<String> selectedWeekdays = []; 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Habit"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveHabit();
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
          TextField(
            controller: frequencyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Frequency (Times per Day)',
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

void saveHabit() async {

    int frequency = int.tryParse(frequencyController.text) ?? 0;

  
    Habit newHabit = Habit(
      id: '',
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

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('Habits')
        .add(newHabit.toMap());

    newHabit.id = docRef.id;

    await docRef.update({'id': newHabit.id});

    DateTime now = DateTime.now();
    DateTime scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTimeController.hour,
      reminderTimeController.minute,
    );

    NotificationService.showScheduledNotification(
      newHabit.title,
      newHabit.description,
      scheduledDateTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Habit added successfully!')),
    );

  
    resetForm();
    Navigator.pushNamed(context, '/home');
  }

  void resetForm() {
    setState(() {
      habitNameController.clear();
      descriptionController.clear();
      frequencyController.clear();
      startDateController = DateTime.now();
      endDateController = DateTime.now().add(const Duration(days: 1));
      reminderTimeController = TimeOfDay.now();
      selectedWeekdays.clear();
      daysController.clear();
    });
  


  void resetForm() {
    setState(() {
      habitNameController.clear();
      descriptionController.clear();
      frequencyController.clear();
      startDateController = DateTime.now();
      endDateController = DateTime.now().add(const Duration(days: 1));
      reminderTimeController = TimeOfDay.now();
      selectedWeekdays.clear();
      daysController.clear();
    });
  }
}
}