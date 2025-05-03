import 'package:flutter/material.dart';
import '../../../utils/button_style.dart';
import '../delete_appointement.dart';
import '../edit_appointement_page.dart';

class AppointmentActionButtons extends StatelessWidget {
  final BuildContext context;
  final int index;
  final Map<String, dynamic> appointment;
  final Function fetchData;

  const AppointmentActionButtons({
    Key? key,
    required this.context,
    required this.index,
    required this.appointment,
    required this.fetchData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Edit button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAppointmentPage(
                  documentId: appointment['id'],
                  appointmentData: appointment,
                  onAppointmentUpdated: () => fetchData(),
                ),
              ),
            );
          },
          style: ButtonStyles.elevatedButtonStyle(Colors.green),
          child: const Text("Edit", style: ButtonStyles.buttonTextStyle),
        ),
        const SizedBox(width: 20),
        // Delete button
        ElevatedButton(
          onPressed: () => AppointmentDeleteHandler.showDeleteConfirmation(
            context: context,
            appointmentId: appointment['id'],
          ),
          style: ButtonStyles.elevatedButtonStyle(Colors.red),
          child: const Text("Delete", style: ButtonStyles.buttonTextStyle),
        ),
      ],
    );
  }
}