// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_appointement_page.dart';
import 'edit_appointement_page.dart';

// Main appointment management page widget
class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

// State class for managing appointment data and UI
class _AppointmentPageState extends State<AppointmentPage> {
  // List to store fetched appointments
  List<Map<String, dynamic>> appointmentList = [];

  // Fetch appointments from Firestore
  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('appointments').get();
    setState(() {
      // Convert documents to map format including document ID
      appointmentList = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Load data when widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointments',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade400,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: RefreshIndicator(
          onRefresh: fetchData, // Pull-to-refresh functionality
          child: appointmentList.isEmpty
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent.shade400,
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.only(bottom: 80),
            itemCount: appointmentList.length,
            itemBuilder: (context, index) {
              final appointment = appointmentList[index];
              return Card(
                margin: EdgeInsets.all(6),
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display patient name
                      _buildInfoRow(Icons.person,
                          "Name: ${appointment['patientName'] ?? 'No Name'}"),
                      SizedBox(height: 12),
                      // Display appointment reason
                      _buildInfoRow(Icons.assignment,
                          "Reason: ${appointment['reason'] ?? 'No Reason'}",
                          isMultiline: false),
                      SizedBox(height: 12),
                      // Display appointment date
                      _buildInfoRow(Icons.calendar_today,
                          "Date: ${appointment['date'] ?? 'No Date'}"),
                      SizedBox(height: 12),
                      // Display appointment time
                      _buildInfoRow(Icons.access_time,
                          "Time: ${appointment['time'] ?? 'No Time'}"),
                      SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300),
                      // Edit/Delete buttons
                      _buildActionButtons(context, index, appointment),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  // Helper widget to create consistent info rows with icons
  Widget _buildInfoRow(IconData icon, String text, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment:
      isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueAccent.shade400, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isMultiline ? 14 : 15,
              fontWeight: isMultiline ? FontWeight.normal : FontWeight.w500,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  // Create edit and delete buttons for each appointment
  Widget _buildActionButtons(
      BuildContext context, int index, Map<String, dynamic> appointment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Edit button
        ElevatedButton(
          onPressed: () => editAppointment(
            context,
            fetchData,
            appointment['id'],
            {
              'patientName': appointment['patientName'],
              'date': appointment['date'],
              'time': appointment['time'],
              'reason': appointment['reason'],
            },
          ),
          style: _buttonStyle(Colors.green),
          child: const Text("Edit", style: _buttonTextStyle),
        ),
        SizedBox(width: 20),
        // Delete button
        ElevatedButton(
          onPressed: () => _confirmDelete(context, index),
          style: _buttonStyle(Colors.red),
          child: const Text("Delete", style: _buttonTextStyle),
        ),
      ],
    );
  }

  // Create floating action button for adding new appointments
  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 31),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () => addAppointment(context, fetchData),
            icon: const Icon(Icons.add),
            label: const Text('Add Appointment'),
            backgroundColor: Colors.blueAccent.shade400,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog before deletion
  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteAppointment(index);
              Navigator.pop(context);
            },
            style: _buttonStyle(Colors.red, horizontalPadding: 16),
            child: const Text("Delete", style: _buttonTextStyle),
          ),
        ],
      ),
    );
  }

  // Delete appointment from Firestore
  Future<void> _deleteAppointment(int index) async {
    String documentId = appointmentList[index]['id'];
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(documentId)
        .delete();
    fetchData(); // Refresh the list after deletion
  }

  // Create consistent button styling
  ButtonStyle _buttonStyle(Color color, {double horizontalPadding = 16}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: 8),
    );
  }

  // Text style for buttons
  static const _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}