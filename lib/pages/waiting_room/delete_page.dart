import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Delete functionality class
class DeletePatientService {
  // Delete patient from Firestore
  static Future<void> deletePatient(String patientId) async {
    await FirebaseFirestore.instance
        .collection('waiting_room')
        .doc(patientId)
        .delete();
  }

  // Show delete confirmation dialog
  static Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required String patientName,
    required Function() onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Patient'),
          content: Text('Are you sure you want to delete $patientName?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal:
                      16, // replaced horizontalPadding with a fixed value
                  vertical: 8,
                ),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Delete button widget
  static Widget buildDeleteButton({
    required BuildContext context,
    required String patientName,
    required String patientId,
  }) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDeleteConfirmationDialog(
          context: context,
          patientName: patientName,
          onConfirm: () => deletePatient(patientId),
        );
      },
    );
  }
}
