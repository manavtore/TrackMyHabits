import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/Models/dates.dart';
import 'package:habit_tracker/core/Models/habit.dart';
import 'package:habit_tracker/core/Models/subHabit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EasyInfiniteDateTimelineController _controller =
      EasyInfiniteDateTimelineController();
   
  int _selectedIndex = 0;

  List<Habit> _habitsForSelectedDate = [];
  int _totalScore = 0;

  @override
  void initState() {
    super.initState();
    _fetchHabitsForDate(DateTime.now());
    _fetchCurrentDateData(DateTime.now());
  }

  Future<void> _fetchHabitsForDate(DateTime date) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: No user is currently logged in.");
        return;
      }
      final userId = user.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Habits')
          .where('userid', isEqualTo: userId)
          .get();

      List<Habit> habits = querySnapshot.docs.map((doc) {
        return Habit.fromMap(doc.data());
      }).toList();

      List<Habit> habitsForSelectedDate = habits.where((habit) {
        return date.isAfter(habit.startDate) &&
            date.isBefore(habit.endDate) &&
            !habit.isComplete;
      }).toList();

      setState(() {
        _habitsForSelectedDate = habitsForSelectedDate;
      });

      _calculateAndStoreScore(date, habitsForSelectedDate);
    } catch (e) {
      print("Error fetching habits: $e");
    }
  }

 Future<void> fetchHabitsForMonth(DateTime month) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: No user is currently logged in.");
        return;
      }
      final userId = user.uid;

      DateTime startOfMonth = DateTime(month.year, month.month, 1);
      DateTime endOfMonth = DateTime(month.year, month.month + 1, 0);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('Habits')
          .where('userid', isEqualTo: userId)
          .get();

      List<Habit> habits = querySnapshot.docs.map((doc) {
        return Habit.fromMap(doc.data());
      }).toList();

      for (DateTime date = startOfMonth;
          date.isBefore(endOfMonth.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        List<Habit> habitsForSelectedDate = habits.where((habit) {
          return date.isAfter(habit.startDate) &&
              date.isBefore(habit.endDate) &&
              !habit.isComplete;
        }).toList();

        await _calculateAndStoreScore(date, habitsForSelectedDate);

        // Debugging: print the date and score
        print("Date: $date, Score: ${habitsForSelectedDate.length}");
      }
    } catch (e) {
      print("Error fetching habits for month: $e");
    }
  }


  Future<void> _calculateAndStoreScore(
      DateTime date, List<Habit> habits) async {
    int completedCount = habits.where((habit) => habit.isComplete).length;
    int score =
        habits.isEmpty ? 0 : ((completedCount / habits.length) * 10).toInt();

    List<SubHabit> subHabitsOfTheDay = habits.map((habit) {
      return SubHabit(
        title: habit.title,
        habitid: habit.id,
        isComplete: habit.isComplete,
      );
    }).toList();

    CurrentDate currentDate = CurrentDate(
      userid: FirebaseAuth.instance.currentUser!.uid,
      score: score,
      date: date.toIso8601String().split('T')[0],
      habitsOfTheDay: subHabitsOfTheDay,
    );

    try {
      await FirebaseFirestore.instance
          .collection('CurrentDates')
          .doc('${currentDate.date}${currentDate.userid}')
          .set(currentDate.toMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error storing score: $e");
    }
  }

  void _onMonthSelected(DateTime selectedMonth) {
    fetchHabitsForMonth(selectedMonth);
  }

  Future<void> _fetchCurrentDateData(DateTime date) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: No user is currently logged in.");
        return;
      }
      final userId = user.uid;
      final dateKey = date.toIso8601String().split('T')[0];

      final docSnapshot = await FirebaseFirestore.instance
          .collection('CurrentDates')
          .doc('$dateKey$userId')
          .get();

      if (docSnapshot.exists) {
        final currentDateData = docSnapshot.data();
        if (currentDateData != null) {
          final currentDate = CurrentDate.fromMap(currentDateData);
          setState(() {
            _totalScore = currentDate.score ?? 0;
          });
        } else {
          print("Error: Document data is null.");
          setState(() {
            _totalScore = 0;
          });
        }
      } else {
        setState(() {
          _totalScore = 0;
        });
      }
    } catch (e) {
      print("Error fetching current date data: $e");
    }
  }

  Future<void> _addOrUpdateHabit(Habit habit) async {
    try {
      await FirebaseFirestore.instance
          .collection('Habits')
          .doc(habit.id)
          .set(habit.toMap(), SetOptions(merge: true));
    } catch (e) {
      print("Error adding/updating habit: $e");
    }
  }

  void _onDateSelected(DateTime selectedDate) {
    _fetchHabitsForDate(selectedDate);
    _fetchCurrentDateData(selectedDate);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/Stats');
          break;
        case 1:
          Navigator.pushNamed(context, '/newHabit');
          break;
        case 2:
          Navigator.pushNamed(context, '/Settings');
          break;
      }
    });
  }

  Future<void> _toggleHabitCompletion(Habit habit) async {
    try {
      DateTime now = DateTime.now();
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Error: No user is currently logged in.");
        return;
      }
      final userId = user.uid;
      final dateKey = now.toIso8601String().split('T')[0];

      setState(() {
        habit.isComplete = !habit.isComplete;
        habit.streak += habit.isComplete ? 1 : -1;
      });

      await _addOrUpdateHabit(habit);

      final docSnapshot = await FirebaseFirestore.instance
          .collection('CurrentDates')
          .doc('$dateKey$userId')
          .get();

      if (docSnapshot.exists) {
        final currentDateData = docSnapshot.data();
        if (currentDateData != null) {
          final currentDate = CurrentDate.fromMap(currentDateData);

          List<SubHabit> updatedHabitsOfTheDay = currentDate.habitsOfTheDay;

          final index = updatedHabitsOfTheDay.indexWhere(
            (subHabit) => subHabit.habitid == habit.id,
          );

          if (index != -1) {
            updatedHabitsOfTheDay[index] = SubHabit(
              title: habit.title,
              habitid: habit.id,
              isComplete: habit.isComplete,
            );
          }

          currentDate.habitsOfTheDay = updatedHabitsOfTheDay;
          currentDate.calculateScore();

          await FirebaseFirestore.instance
              .collection('CurrentDates')
              .doc('$dateKey$userId')
              .set(currentDate.toMap(), SetOptions(merge: true));

          setState(() {
            _totalScore = currentDate.score;
          });
        }
      }
    } catch (e) {
      print("Error updating habit completion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit Tracker"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.pushNamed(context, '/habitCalender');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {
                _onDateSelected(selectedDate);
              },
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _habitsForSelectedDate.length,
              itemBuilder: (context, index) {
                Habit habit = _habitsForSelectedDate[index];
                return ListTile(
                  leading: Checkbox(
                    value: habit.isComplete,
                    onChanged: (value) {
                      _toggleHabitCompletion(habit);
                    },
                  ),
                  title: Text(habit.title),
                  subtitle: Row(
                    children: [
                      Text("Streak: ${habit.streak}"),
                      const SizedBox(width: 10),
                      Text("Score: $_totalScore"),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/habitDetails',
                        arguments: habit);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Habit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
