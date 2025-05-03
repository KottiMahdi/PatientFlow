import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../appointement/appointement_page.dart';


// Function to create a modified version of addAppointment that includes patient data
void schedulePatientAppointment(BuildContext context, QueryDocumentSnapshot patientData, VoidCallback fetchData) {
  // Get patient data
  final Map<String, dynamic> data = patientData.data() as Map<String, dynamic>;
  final String patientName = '${data['name']} ${data['prenom']}';

  // Controllers for text input fields
  final _patientNameController = TextEditingController(text: patientName); // Pre-filled with patient name
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Variables to store selected date and time
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Function to show date picker dialog
  void _selectDate(BuildContext context, Function setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2161),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Time picker function
  void _selectTime(BuildContext context, Function setState) async {
    // Show time picker dialog
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(), // Current time or existing selection
    );
    // Update state if valid time selected
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  // Show the appointment creation dialog
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Schedule Appointment for $patientName",
          style: TextStyle(
              color: Colors.blueAccent.shade400,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        // Use StatefulBuilder to manage state within the dialog
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Patient Name Input (read-only since pre-filled)
                    TextFormField(
                      controller: _patientNameController,
                      readOnly: true, // Make it read-only
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                        Icon(Icons.person, color: Colors.blueAccent.shade400),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Appointment reason input field
                    TextFormField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: 'Reason for Appointment',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                        Icon(Icons.account_tree_rounded, color: Colors.blueAccent.shade400),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter reason for appointment';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Date selection with validation
                    FormField<DateTime>(
                      validator: (value) {
                        if (selectedDate == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      builder: (FormFieldState<DateTime> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectDate(context, setState);
                              },
                              child: Text(selectedDate == null
                                  ? 'Select Date'
                                  : 'Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                minimumSize: Size(double.infinity, 48),
                              ),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 12),

                    // Time selection with validation
                    FormField<TimeOfDay>(
                      validator: (value) {
                        if (selectedTime == null) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                      builder: (FormFieldState<TimeOfDay> state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _selectTime(context, setState);
                              },
                              child: Text(selectedTime == null
                                  ? 'Select Time'
                                  : 'Selected Time: ${selectedTime!.format(context)}'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                minimumSize: Size(double.infinity, 48),
                              ),
                            ),
                            if (state.hasError)
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  state.errorText!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
        // Dialog action buttons
        actions: [
          // Cancel button
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          // Add button
          ElevatedButton(
            onPressed: () async {
              // Validate required fields
              if (_formKey.currentState!.validate()) {
                // Add new appointment to Firestore
                await FirebaseFirestore.instance
                    .collection('appointments')
                    .add({
                  'patientName': _patientNameController.text,
                  'patientId': patientData.id, // Store the patient ID for reference
                  'date': '${selectedDate!.toLocal().day}/${selectedDate!.toLocal().month}/${selectedDate!.toLocal().year}',
                  'time': selectedTime!.format(context),
                  'reason': _reasonController.text,
                });

                await FirebaseFirestore.instance
                    .collection('waiting_room')
                    .add({
                  'name': _patientNameController.text.trim(),
                  'time': selectedTime!.format(context),
                  'createdAt': FieldValue.serverTimestamp(),
                  'status': 'RDV',
                  'date': '${selectedDate!.toLocal().day}/${selectedDate!.toLocal().month}/${selectedDate!.toLocal().year}',
                });

                Navigator.of(context).pop(); // Close the dialog
                fetchData(); // Optional: Refresh data if needed

              }
            },
            child: Text("Schedule"),
          ),
        ],
      );
    },
  );
}

