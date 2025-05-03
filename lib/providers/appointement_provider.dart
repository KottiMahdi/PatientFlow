import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _appointmentList = [];
  DateTime _selectedDate = DateTime.now();
  bool _isDataLoaded = false;
  bool _isManualDateSelection = false;

  // Getters
  List<Map<String, dynamic>> get appointmentList => _appointmentList;
  DateTime get selectedDate => _selectedDate;
  bool get isDataLoaded => _isDataLoaded;
  bool get isManualDateSelection => _isManualDateSelection;

  // Set selected date and notify listeners
  void setSelectedDate(DateTime date, {bool isManual = true}) {
    _selectedDate = date;
    _isManualDateSelection = isManual;
    notifyListeners();
    fetchData(); // Refresh data with new date
  }

  // Reset date to today
  void resetToToday() {
    _selectedDate = DateTime.now();
    _isManualDateSelection = false;
    notifyListeners();
    fetchData();
  }

  // Fetch appointments from Firestore
  Future<void> fetchData() async {
    try {
      // Query Firestore for all appointments
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('appointments').get();

      print(
          "Data fetched successfully: ${querySnapshot.docs.length} appointments");

      // Convert QuerySnapshot to a list of maps with appointment data
      _appointmentList = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include document ID
          ...doc.data() as Map<String, dynamic>, // Include all document fields
        };
      }).toList();

      // Filter appointments to show only those for the selected date
      final selectedDateString =
      DateFormat('d/M/yyyy').format(_selectedDate);
      print("Filtering appointments for date: $selectedDateString");

      _appointmentList = _appointmentList.where((appointment) {
        return appointment['date'] == selectedDateString;
      }).toList();

      // Sort appointments by time of day
      _appointmentList.sort((a, b) {
        // Parse time strings to TimeOfDay objects
        TimeOfDay timeA = TimeOfDay(
            hour: int.parse(a['time'].split(':')[0]),
            minute: int.parse(a['time'].split(':')[1].split(' ')[0]));
        TimeOfDay timeB = TimeOfDay(
            hour: int.parse(b['time'].split(':')[0]),
            minute: int.parse(b['time'].split(':')[1].split(' ')[0]));

        // Convert times to minutes for comparison
        int minutesA = timeA.hour * 60 + timeA.minute;
        int minutesB = timeB.hour * 60 + timeB.minute;

        return minutesA.compareTo(minutesB);
      });

      _isDataLoaded = true;
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Add new appointment
  Future<void> addAppointment({
    required String patientName,
    required String date, // In 'd/M/yyyy' format
    required String time,
    required String reason,
  }) async {
    try {
      // Add to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientName': patientName,
        'date': date,
        'time': time,
        'reason': reason,
      });

      // Add to waiting room
      await FirebaseFirestore.instance.collection('waiting_room').add({
        'name': patientName.trim(),
        'time': time,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'RDV',
        'date': date,
      });

      // Refresh appointments list
      await fetchData();
    } catch (e) {
      print("Error adding appointment: $e");
      rethrow; // Re-throw to handle in UI
    }
  }

  // Update existing appointment
  Future<void> updateAppointment({
    required String documentId,
    required String patientName,
    required String date, // In 'd/M/yyyy' format
    required String time,
    required String reason,
    required String oldPatientName,
    required String oldDate,
  }) async {
    try {
      // Update appointment in Firestore
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .update({
        'patientName': patientName,
        'date': date,
        'time': time,
        'reason': reason,
      });

      // Update corresponding waiting room entry if it exists
      QuerySnapshot waitingRoomQuery = await FirebaseFirestore.instance
          .collection('waiting_room')
          .where('name', isEqualTo: oldPatientName)
          .where('date', isEqualTo: oldDate)
          .get();

      if (waitingRoomQuery.docs.isNotEmpty) {
        for (var doc in waitingRoomQuery.docs) {
          await FirebaseFirestore.instance
              .collection('waiting_room')
              .doc(doc.id)
              .update({
            'name': patientName.trim(),
            'time': time,
            'date': date,
          });
        }
      }

      // Refresh appointments list
      await fetchData();
    } catch (e) {
      print("Error updating appointment: $e");
      rethrow; // Re-throw to handle in UI
    }
  }

  // Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();

      // Refresh appointments list
      await fetchData();
    } catch (e) {
      print("Error deleting appointment: $e");
      rethrow; // Re-throw to handle in UI
    }
  }
}