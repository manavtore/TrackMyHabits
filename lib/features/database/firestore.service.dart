import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> fetchAndPushMonth(String year, String month) async {
    int monthNum = int.parse(month);
    int yearNum = int.parse(year);

    DateTime startDate = DateTime(yearNum, monthNum, 1);
    DateTime endDate =
        DateTime(yearNum, monthNum + 1, 0); 

    final snapshot = await _firestore
        .collection('AllDates')
        .where('userid', isEqualTo: userid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    List<Map<String, dynamic>> datesForCurrentMonth = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      datesForCurrentMonth.add(data);
    }

    if (datesForCurrentMonth.isNotEmpty) {
      await _firestore
          .collection('Years')
          .doc(year)
          .collection('Months')
          .doc(month)
          .set({
        'userid': userid,
        'dates': datesForCurrentMonth,
      });
    }
  }
}
