import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/appointement_provider.dart';

class EditAppointmentPage extends StatefulWidget {
  final String documentId;
  final Map<String, dynamic> appointmentData;
  final VoidCallback onAppointmentUpdated;

  const EditAppointmentPage({
    Key? key,
    required this.documentId,
    required this.appointmentData,
    required this.onAppointmentUpdated,
  }) : super(key: key);

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  // Controllers for text input fields
  late final TextEditingController _patientNameController;
  late final TextEditingController _reasonController;
  final _formKey = GlobalKey<FormState>();

  // Variables to store selected date and time
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing appointment data
    _patientNameController = TextEditingController(text: widget.appointmentData['patientName']);
    _reasonController = TextEditingController(text: widget.appointmentData['reason']);

    // Parse existing date from appointment data (DD/MM/YYYY format)
    try {
      String dateStr = widget.appointmentData['date'];
      List<String> dateParts = dateStr.split('/');
      if (dateParts.length == 3) {
        selectedDate = DateTime(
          int.parse(dateParts[2]), // Year
          int.parse(dateParts[1]), // Month
          int.parse(dateParts[0]), // Day
        );
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    // Parse existing time from appointment data
    try {
      String timeStr = widget.appointmentData['time'];
      final format = DateFormat.Hm(); // Hour:Minute format
      DateTime dateTime = format.parse(timeStr);
      selectedTime = TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      print('Error parsing time: $e');
    }
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  // Function to show date picker dialog
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2161),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Time picker function
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  // Function to update appointment in Firestore
  Future<void> _updateAppointment() async {
    // Validate required fields
    if (_formKey.currentState!.validate()) {
      try {
        // Format date and time strings
        String dateString = '${selectedDate!.toLocal().day}/${selectedDate!.toLocal().month}/${selectedDate!.toLocal().year}';
        String timeString = selectedTime!.format(context);

        // Get provider reference
        final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);

        // Use provider to update appointment
        await appointmentProvider.updateAppointment(
          documentId: widget.documentId,
          patientName: _patientNameController.text,
          date: dateString,
          time: timeString,
          reason: _reasonController.text,
          oldPatientName: widget.appointmentData['patientName'],
          oldDate: widget.appointmentData['date'],
        );

        // Call the callback to refresh appointment list
        widget.onAppointmentUpdated();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment updated successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        Navigator.of(context).pop();
      } catch (e) {
        // Show error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating appointment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(0xFF2A79B0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Patient Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A79B0),
                ),
              ),
              SizedBox(height: 16),

              // Patient Name Input
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF2A79B0)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              Text(
                "Appointment Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A79B0),
                ),
              ),
              SizedBox(height: 16),

              // Appointment reason input field
              TextFormField(
                maxLines: 3,
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason for Appointment',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.notes, color: Color(0xFF2A79B0)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter reason for appointment';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              Text(
                "Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2A79B0),
                ),
              ),
              SizedBox(height: 16),

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
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                          state.didChange(selectedDate);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Color(0xFF2A79B0)),
                              SizedBox(width: 16),
                              Text(
                                selectedDate == null
                                    ? 'Select Date'
                                    : 'Date: ${selectedDate!.toLocal().day}/${selectedDate!.toLocal().month}/${selectedDate!.toLocal().year}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
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
              SizedBox(height: 16),

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
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                          state.didChange(selectedTime);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: Color(0xFF2A79B0)),
                              SizedBox(width: 16),
                              Text(
                                selectedTime == null ? 'Select Time' : 'Time: ${selectedTime!.format(context)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
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
              SizedBox(height: 40),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Cancel"),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF2A79B0)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _updateAppointment,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Update"),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2A79B0),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}