import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../delete_patient_page.dart'; // Import the delete patient page functionality

// Function to Show a Popup with Options (Edit or Delete) for a Patient
void showOptionsPopup(BuildContext context, QueryDocumentSnapshot patientData) {
  // Explicitly cast the data from Firestore to a map for easy access
  final Map<String, dynamic> data = patientData.data() as Map<String, dynamic>;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)), // Rounded top corners for the modal
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the modal content
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize the height of the modal based on its content
          children: [
            // Display Patient Name and Surname
            Text(
              '${data['name']} ${data['prenom']}', // Patient's full name
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12), // Space between name and buttons

            // Row with Edit and Delete Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Space evenly around buttons
              children: [
                // Edit Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                    //_editPatient(context, data); // Uncomment this to enable editing functionality
                  },
                  icon: const Icon(Icons.edit), // Edit icon
                  label: const Text('Edit'), // Button label
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Blue background for the button
                    foregroundColor: Colors.white, // White text and icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                  ),
                ),

                // Delete Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                    deletePatient(context, patientData); // Call the delete function with the patient snapshot
                  },
                  icon: const Icon(Icons.delete), // Delete icon
                  label: const Text('Delete'), // Button label
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Red background for the button
                    foregroundColor: Colors.white, // White text and icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
