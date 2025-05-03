import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/edit_patient_page.dart';
import '../delete_patient_page.dart';
import '../schedule_appointment_patient.dart';

void showOptionsPopup(BuildContext context, QueryDocumentSnapshot patientData,
    VoidCallback fetchPatientsData) {
  final Map<String, dynamic> data = patientData.data() as Map<String, dynamic>;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Center(
          child: Text(
            '${data['name']} ${data['prenom']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            // Edit/Delete Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Edit Button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPatientPage(patientData: patientData),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text('Edit', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2A79B0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ),

                // Delete Button
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        deletePatient(context, patientData);
                      },
                      icon: const Icon(Icons.delete, size: 20),
                      label:
                          const Text('Delete', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Schedule Appointment Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                schedulePatientAppointment(
                    context, patientData, fetchPatientsData);
              },
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text('Schedule Appointment',
                  style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: const Size(double.infinity, 48),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}
