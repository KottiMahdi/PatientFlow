import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// The main StatefulWidget that displays the list of patients
class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

// The state class for PatientsPage, where the UI and logic are defined
class _PatientsPageState extends State<PatientsPage> {
  // List to store fetched data from Firestore
  List<QueryDocumentSnapshot> data = [];

  // Fetches data from the "patients" collection in Firestore and updates the local data list
  getData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("patients").get();
      // Add fetched documents to the data list
      data.addAll(querySnapshot.docs);
      // Update UI to reflect the new data
      setState(() {});
    } catch (e) {
      // Log an error message if fetching data fails
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch patient data when the widget is initialized
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title for the page
      appBar: AppBar(
        title: const Text('List of patients'),
      ),
      // Body containing a ListView to display the list of patients
      body: ListView.builder(
        itemCount: data.length, // Number of patients
        itemBuilder: (context, index) {
          var patientData = data[index]; // Fetch individual patient data
          return ListTile(
            leading: const Icon(Icons.person), // Icon for each patient
            title: Text(patientData['name']), // Display patient name
            trailing: IconButton(
              icon: const Icon(Icons.more_vert), // Icon for more options
              onPressed: () {
                // Show patient details in a modal when the button is pressed
                _showPatientDetails(context, patientData);
              },
            ),
          );
        },
      ),
    );
  }

  // Function to show detailed patient information in a modal bottom sheet
  void _showPatientDetails(BuildContext context, QueryDocumentSnapshot patientData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow modal to take more space if needed
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0), // Add padding inside modal
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title for patient details section
                const Text(
                  'Patient Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Divider(), // Horizontal divider for visual separation
                const SizedBox(height: 10), // Vertical spacing between elements

                // Patient information rows with labels and corresponding data values
                _buildDetailRow('Dernier RDV', patientData['Dernier RDV'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Prochain RDV', patientData['Prochain RDV'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Group Sanguin', patientData['groupSanguin'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Date Naiss', patientData['dateNaiss'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Age', patientData['age']?.toString() ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Adresse', patientData['adresse'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Etat Civil', patientData['etatCivil'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Genre', patientData['genre'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Tel', patientData['tel'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Tel WhatsApp', patientData['telWhatsApp'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Email',
                  patientData['email'].isNotEmpty ? patientData['email'] : 'N/A',
                ),
                const SizedBox(height: 20), // Space before the close button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the modal when the button is pressed
                      Navigator.pop(context);
                    },
                    child: const Text('Close'), // Button label
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper widget to build a row displaying label and value for patient details
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        // Label with bold font
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Value with flexible width to adjust to screen size
        Flexible(
          child: Text(value),
        ),
      ],
    );
  }
}
