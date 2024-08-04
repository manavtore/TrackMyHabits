// ignore_for_file: camel_case_types

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:from_to_time_picker/from_to_time_picker.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class newHabit extends StatefulWidget {
  const newHabit({super.key});

  @override
  State<newHabit> createState() => _newHabitState();
}

class _newHabitState extends State<newHabit> {

  TextEditingController habitNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  DateTime startDateController = DateTime.now();
  TimeOfDay dateTime=TimeOfDay.now();
  TextEditingController timeController = TextEditingController();


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
     
              // print("this is it");
            },
          ),
        ],
        
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: habitNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Habit Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: frequencyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Frequency',
              ),
            ),
          ),
           EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {
               startDateController = selectedDate; 
               print(selectedDate);
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: frequencyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'No of Days',
              ),
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         color: Colors.grey,
          //         width: 2.0,
          //       ),
          //       borderRadius: BorderRadius.circular(8.0),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.2),
          //           spreadRadius: 2,
          //           blurRadius: 5,
          //           offset: const Offset(0, 3),
          //         ),
          //       ],
          //     ),
          //     child: TimePickerSpinner(
          //       locale: const Locale('en', ''),
          //       time: DateTime.now(),
          //       is24HourMode: false,
          //       isShowSeconds: true,
          //       itemHeight: 70,
          //       normalTextStyle: const TextStyle(
          //         fontSize: 24,
          //       ),
          //       highlightedTextStyle: const TextStyle(
          //         fontSize: 24,
          //         color: Colors.blue,
          //       ),
          //       isForce2Digits: true,
          //       onTimeChange: (time) {
          //         setState(() {
          //           dateTime = dateTime;
          //         });
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}