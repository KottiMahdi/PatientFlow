import 'package:flutter/material.dart';
import '../data.dart'; // Import the file where the patient data is defined

// The main StatefulWidget that displays the list of patients
class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() =>
      _PatientsPageState(); // Create the state for PatientsPage
}

// The state class for PatientsPage, where the UI and logic are defined
class _PatientsPageState extends State<PatientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A Scaffold widget to provide the basic structure of the page (app bar, body)
      appBar: AppBar(
        title: Text('List of patients'), // AppBar title
      ),
      body: ListView.builder(
        itemCount: patients
            .length, // Number of items in the list (based on the number of patients)
        itemBuilder: (context, index) {
          return ListTile(
            leading:
                Icon(Icons.person), // Icon displayed before each patient's name
            title: Text(patients[index].name), // Display the patient's name
            trailing: IconButton(
              icon:
                  Icon(Icons.more_vert), // Icon for additional options
              onPressed: () {
                // When the user presses the button, show more patient details
                _showPatientDetails(context, patients[index]);
              },
            ),
          );
        },
      ),
    );
  }

  // Function to show patient details in a modal bottom sheet
  void _showPatientDetails(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the modal to take more space if necessary
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0), // Add padding inside the modal
          child: SingleChildScrollView(
            // Make the content scrollable if it exceeds the screen height
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align the content to the left
              children: <Widget>[
                Text(
                  'Patient Details',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold), // Title with bold text
                ),
                Divider(), // A horizontal line to separate sections
                SizedBox(height: 10), // Add vertical space between elements
                _buildDetailRow('Dernier RDV',
                    ''), // Placeholder for the last appointment date
                SizedBox(height: 8), // Vertical space between fields
                _buildDetailRow('Prochain RDV',
                    ''), // Placeholder for the next appointment date
                SizedBox(height: 8),
                _buildDetailRow('Group Sanguin',
                    patient.groupSanguin), // Display blood group
                SizedBox(height: 8),
                _buildDetailRow(
                    'Date Naiss', patient.dateNaiss), // Display date of birth
                SizedBox(height: 8),
                _buildDetailRow('Age', patient.age.toString()), // Display age
                SizedBox(height: 8),
                _buildDetailRow('Adresse', patient.adresse), // Display address
                SizedBox(height: 8),
                _buildDetailRow(
                    'Etat Civil', patient.etatCivil), // Display marital status
                SizedBox(height: 8),
                _buildDetailRow('Genre', patient.genre), // Display gender
                SizedBox(height: 8),
                _buildDetailRow('Tel', patient.tel), // Display phone number
                SizedBox(height: 8),
                _buildDetailRow('Tel WhatsApp',
                    patient.telWhatsApp), // Display WhatsApp number
                SizedBox(height: 8),
                _buildDetailRow(
                    'Email',
                    patient.email.isNotEmpty
                        ? patient.email
                        : 'N/A'), // Display email or N/A if empty
                SizedBox(height: 20), // Add space before the close button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                          context); // Close the modal when the button is pressed
                    },
                    child: Text('Close'), // Text displayed on the button
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget to build a row of details (label and value)
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ',
            style:
                TextStyle(fontWeight: FontWeight.bold)), // Label with bold font
        Flexible(
            child: Text(
                value)), // The value (text) is flexible to adjust to screen width
      ],
    );
  }
}
