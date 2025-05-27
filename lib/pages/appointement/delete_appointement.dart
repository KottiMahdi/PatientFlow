import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/appointement_provider.dart';
import '../../utils/button_style.dart';

class AppointmentDeleteHandler {
  // Show confirmation dialog before deleting an appointment
  static void showDeleteConfirmation({
    required BuildContext context,
    required String appointmentId,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              _performDelete(context, appointmentId); // Perform delete
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

  // Separate method to handle the actual deletion
  static Future<void> _performDelete(BuildContext context, String appointmentId) async {
    // Store references before async operations
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    // Show loading dialog and store its context
    BuildContext? loadingDialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        loadingDialogContext = dialogContext; // Store the dialog context
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Deleting appointment...'),
            ],
          ),
        );
      },
    );

    try {
      print("Starting deletion process for appointment: $appointmentId");

      // Perform deletion
      await appointmentProvider.deleteAppointment(appointmentId);

      // Close loading dialog using the stored context
      if (loadingDialogContext != null && loadingDialogContext!.mounted) {
        Navigator.of(loadingDialogContext!).pop();
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment deleted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      print("Appointment deleted successfully");

    } catch (e) {
      print("Delete operation failed: $e");

      // Close loading dialog using the stored context
      if (loadingDialogContext != null && loadingDialogContext!.mounted) {
        Navigator.of(loadingDialogContext!).pop();
      }

      // Determine error message
      String errorMessage = 'Failed to delete appointment';
      if (e.toString().contains('Appointment not found')) {
        errorMessage = 'Appointment not found or already deleted';
      } else if (e.toString().contains('permission')) {
        errorMessage = 'Permission denied. Please check your access rights';
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}