import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentService {
  // Assuming appointmentList is a list of maps containing appointment data
  List<Map<String, dynamic>> appointmentList = [];

  // Method to delete an appointment
  void deleteAppointment(int index) async {
    // Get the document ID from the appointment map
    String documentId = appointmentList[index]['id'];

    // Delete the document from Firestore
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(documentId)
        .delete();

    // Refresh the list
    fetchData();
  }

  // Method to fetch data (assuming it's defined elsewhere)
  void fetchData() {
    // Implement the logic to fetch data from Firestore or another source
    // For example:
    // FirebaseFirestore.instance.collection('appointments').get().then((querySnapshot) {
    //   appointmentList = querySnapshot.docs.map((doc) => doc.data()).toList();
    // });
  }
}