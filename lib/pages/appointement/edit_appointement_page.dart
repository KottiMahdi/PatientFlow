import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void editAppointment(BuildContext context, VoidCallback fetchData,
    String documentId, Map<String, dynamic> appointmentData) {
  final _patientNameController =
      TextEditingController(text: appointmentData['patientName']);
  final _reasonController =
      TextEditingController(text: appointmentData['reason']);
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Parse existing date
  try {
    String dateStr = appointmentData['date'];
    List<String> dateParts = dateStr.split('/');
    if (dateParts.length == 3) {
      selectedDate = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
    }
  } catch (e) {
    print('Error parsing date: $e');
  }

  // Parse existing time
  try {
    String timeStr = appointmentData['time'];
    final format = DateFormat.Hm();
    DateTime dateTime = format.parse(timeStr);
    selectedTime = TimeOfDay.fromDateTime(dateTime);
  } catch (e) {
    print('Error parsing time: $e');
  }

  //This function opens a date picker dialog and updates the selectedDate when a date is picked.
  void _selectDate(BuildContext context, Function setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2161),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

//This function opens a time picker dialog and updates the selectedTime when a time is picked.
  void _selectTime(BuildContext context, Function setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Edit Appointment",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _patientNameController,
                    decoration: const InputDecoration(
                      labelText: "Patient Name",
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      labelText: "Reason for Appointment",
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, setState),
                    child: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, setState),
                    child: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Selected Time: ${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedDate != null && selectedTime != null) {
                try {
                  await FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(documentId)
                      .update({
                    'patientName': _patientNameController.text,
                    'date': '${selectedDate!.day}/'
                        '${selectedDate!.month}/'
                        '${selectedDate!.year}',
                    'time': '${selectedTime!.hour.toString().padLeft(2, '0')}:'
                        '${selectedTime!.minute.toString().padLeft(2, '0')}',
                    'reason': _reasonController.text,
                  });
                  fetchData();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating appointment: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select both date and time')),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      );
    },
  );
}
