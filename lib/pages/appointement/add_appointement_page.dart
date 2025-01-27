import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addAppointment(BuildContext context, VoidCallback fetchData) {
  final _patientNameController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _selectDate(BuildContext context, Function setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2161),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context, Function setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Add New Appointment",
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
                    decoration: InputDecoration(
                      labelText: "Patient Name",
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _reasonController,
                    decoration: InputDecoration(
                      labelText: "Reason for Appointment",
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context, setState);
                    },
                    child: Text(selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      minimumSize:
                      Size(double.infinity, 48), // Full-width button
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      _selectTime(context, setState);
                    },
                    child: Text(selectedTime == null
                        ? 'Select Time'
                        : 'Selected Time: ${selectedTime!.format(context)}'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      minimumSize:
                      Size(double.infinity, 48), // Full-width button
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedDate != null && selectedTime != null) {
                await FirebaseFirestore.instance
                    .collection('appointments')
                    .add({
                  'patientName': _patientNameController.text,
                  'date':
                  '${selectedDate!.toLocal().day}/${selectedDate!.toLocal().month}/${selectedDate!.toLocal().year}',
                  'time': selectedTime!.format(context),
                  'reason': _reasonController.text,
                });
                fetchData(); // Refresh the list
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select date and time.')),
                );
              }
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}