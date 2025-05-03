import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/appointement_provider.dart';
import '../../utils/button_style.dart';

class AppointmentDeleteHandler {
  // Show confirmation dialog before deleting an appointment
  static void showDeleteConfirmation({
    required BuildContext context, // This is the key context parameter
    required String appointmentId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Call the delete method with proper context
              await _deleteAppointment(
                context: context,
                appointmentId: appointmentId,
              );
              Navigator.pop(context);
            },
            style: ButtonStyles.elevatedButtonStyle(
              Colors.red,
              horizontalPadding: 16,
            ),
            child: const Text(
              "Delete",
              style: ButtonStyles.buttonTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  // Private static method to handle deletion
  static Future<void> _deleteAppointment({
    required BuildContext context,
    required String appointmentId,
  }) async {
    try {
      await Provider.of<AppointmentProvider>(
        context,
        listen: false,
      ).deleteAppointment(appointmentId);
    } catch (e) {
      print("Error deleting appointment: $e");
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete appointment: ${e.toString()}'),
        ),
      );
    }
  }
}