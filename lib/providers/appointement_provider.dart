import 'package:firebase_auth/firebase_auth.dart';
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print(
          "Data fetched successfully: ${querySnapshot.docs.length} appointments");

      // Convert QuerySnapshot to a list of maps with appointment data
      _appointmentList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Document ID: ${doc.id}, User ID: ${data['id']}, Patient: ${data['patientName']}");
        return {
          'documentId': doc.id, // Store the Firestore document ID separately
          'id': data['id'], // Keep the user ID field
          'patientName': data['patientName'],
          'date': data['date'],
          'time': data['time'],
          'reason': data['reason'],
          // Include any other fields you need
          ...data, // Include all other fields from the document
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
      notifyListeners(); // Even on error, notify to update loading states
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
        'id': FirebaseAuth.instance.currentUser!.uid,
      });

      // Add to waiting room
      await FirebaseFirestore.instance.collection('waiting_room').add({
        'name': patientName.trim(),
        'time': time,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'RDV',
        'date': date,
        'id': FirebaseAuth.instance.currentUser!.uid,
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
      print("Starting appointment update for document ID: $documentId");
      print("Old: $oldPatientName on $oldDate -> New: $patientName on $date");

      // Update appointment in Firestore using update() instead of set()
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .update({
        'patientName': patientName.trim(),
        'date': date,
        'time': time,
        'reason': reason,
      });

      print("Updated appointment in appointments collection");

      // Update corresponding waiting room entry if it exists
      QuerySnapshot waitingRoomQuery = await FirebaseFirestore.instance
          .collection('waiting_room')
          .where('name', isEqualTo: oldPatientName.trim())
          .where('date', isEqualTo: oldDate)
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print("Found ${waitingRoomQuery.docs.length} matching waiting room entries");

      if (waitingRoomQuery.docs.isNotEmpty) {
        // Use batch write for better performance and atomicity
        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (var doc in waitingRoomQuery.docs) {
          print("Updating waiting room entry: ${doc.id}");
          batch.update(
            FirebaseFirestore.instance.collection('waiting_room').doc(doc.id),
            {
              'name': patientName.trim(),
              'time': time,
              'date': date,
            },
          );
        }

        // Commit all updates at once
        await batch.commit();
        print("Successfully updated ${waitingRoomQuery.docs.length} waiting room entries");
      } else {
        print("No waiting room entries found to update");

        // Don't create a new entry automatically - this might cause duplicates
        // Only create if you're sure this is the intended behavior
        print("Consider creating waiting room entry manually if needed");
      }

      print("Appointment update completed successfully");

      // Force refresh the data and notify listeners
      notifyListeners(); // Add this to notify UI of changes
      await fetchData();

    } catch (e) {
      print("Error updating appointment: $e");
      print("Stack trace: ${StackTrace.current}");
      rethrow;
    }
  }

// Also add this method to your provider to force UI refresh
  void refreshUI() {
    notifyListeners();
  }

  // Delete appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      print("Attempting to delete appointment with ID: $appointmentId");

      // First, get the appointment data before deleting it
      DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .get();

      if (!appointmentDoc.exists) {
        print("Appointment document not found with ID: $appointmentId");
        throw Exception('Appointment not found');
      }

      Map<String, dynamic> appointmentData = appointmentDoc.data() as Map<String, dynamic>;
      String patientName = appointmentData['patientName'] ?? '';
      String date = appointmentData['date'] ?? '';

      print("Found appointment for patient: $patientName on date: $date");

      // Delete the appointment from the appointments collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();

      print("Deleted appointment from appointments collection");

      // Delete the corresponding entry from waiting_room collection
      QuerySnapshot waitingRoomQuery = await FirebaseFirestore.instance
          .collection('waiting_room')
          .where('name', isEqualTo: patientName.trim())
          .where('date', isEqualTo: date)
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print("Found ${waitingRoomQuery.docs.length} matching waiting room entries");

      // Delete all matching waiting room entries
      for (var doc in waitingRoomQuery.docs) {
        await FirebaseFirestore.instance
            .collection('waiting_room')
            .doc(doc.id)
            .delete();
        print("Deleted waiting room entry: ${doc.id}");
      }

      print("Appointment and waiting room entry deleted successfully");

      // Refresh appointments list
      await fetchData();
    } catch (e) {
      print("Error deleting appointment: $e");
      rethrow; // Re-throw to handle in UI
    }
  }
}