import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/core/Models/dates.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        title: const Text("Stats"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: fetchAndInsertData,
          child: const Text('Fetch and Insert Data'),
        ),
      ),
    );
  }
}
