import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/Models/habit.dart';
import 'package:intl/intl.dart';

class HabitDetails extends StatefulWidget {
  final Habit habit;

  const HabitDetails({super.key, required this.habit});

  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  var id = FirebaseFirestore.
  instance.collection('Habits').
  where('id', isEqualTo: 'id').
  get();
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    final String formattedStartDate = dateFormat.format(widget.habit.startDate);
    final String formattedEndDate = dateFormat.format(widget.habit.endDate);

    String formatTimeOfDay(TimeOfDay tod) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      final format = DateFormat.jm();
      return format.format(dt);
    }

    final String formattedReminderTime = formatTimeOfDay(widget.habit.reminderTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigator.pushNamed(
              //     context,
              //     AppRoutes.editHabitRoute, arguments: habit.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, widget.habit);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailItem('Title', widget.habit.title),
            _buildDetailItem('Description', widget.habit.description),
            _buildDetailItem('Start Date', formattedStartDate),
            _buildDetailItem('End Date', formattedEndDate),
            _buildDetailItem('Reminder Time', formattedReminderTime),
            _buildWeekdayChips(widget.habit.selectedWeekdays),
            const SizedBox(height: 20),
            _buildStatistics(widget.habit),
            const SizedBox(height: 20),
            _buildCompletionProgress(widget.habit),
            const SizedBox(height: 20),
            _buildActionButtons(context, widget.habit),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildWeekdayChips(List<String> weekdays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Weekdays',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: weekdays
              .map((day) => Chip(
                    label: Text(day),
                    backgroundColor: Colors.blue[100],
                  ))
              .toList(),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildStatistics(Habit habit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatisticItem('Streak', habit.streak.toString()),
            _buildStatisticItem(
                'Total Completions', habit.totalCompletions.toString()),
            _buildStatisticItem('Current Score', habit.streak.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionProgress(Habit habit) {
    final int totalDays = habit.endDate.difference(habit.startDate).inDays + 1;
    final double progress =
        (habit.totalCompletions / totalDays).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Completion Progress',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          minHeight: 8.0,
        ),
        const SizedBox(height: 4.0),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% completed',
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Habit habit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          onPressed: () {
            Navigator.pushNamed(context, '/editHabit', arguments: habit.id);
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text('Delete'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            _showDeleteConfirmation(context, habit);
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: const Text('Are you sure you want to delete this habit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  deleteHabit(habit);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  print("deleted");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Habit deleted successfully!')),
                  );
                } catch (e) {
                  print('Failed to delete habit: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteHabit(Habit habit) async {
    try {
      CollectionReference hb = FirebaseFirestore.instance.collection('Habits');
      QuerySnapshot querySnapshot =
          await hb.where('id', isEqualTo: habit.id).get();
      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        await hb.doc(documentId).delete();
      } else {
        print("No habit found with the given ID");
      }
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }
}
