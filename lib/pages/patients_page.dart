import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  // List to store fetched data from Firestore
  List<QueryDocumentSnapshot> data = [];

  // Fetches data from the "patients" collection in Firestore
  Future<void> getData() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("patients").get();
      // Update the data list with fetched documents
      setState(() {
        data = querySnapshot.docs;
      });
    } catch (e) {
      // Log an error if fetching data fails
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch patient data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'), // Title for the page
      ),
      // Wrap the list with RefreshIndicator for pull-to-refresh functionality
      body: RefreshIndicator(
        onRefresh: getData, // Call getData when refreshing
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Searching',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            // Conditionally display message or list of patients
            Expanded(
              child: data.isEmpty
                  ? const Center(
                child: Text(
                  'No Patients',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                  var patientData = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Card( // Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(patientData['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(patientData['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.phone, color: Colors.blue),
                              onPressed: () {
                                // Call patient
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.message, color: Colors.green),
                              onPressed: () {
                                // WhatsApp message to patient
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Show patient details in a modal
                          _showPatientDetails(context, patientData);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add patient action
        },
        icon: const Icon(Icons.add),
        label: const Text('Add patients'),
        backgroundColor: Colors.blueAccent.shade400,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Function to show detailed patient information in a modal bottom sheet
  void _showPatientDetails(BuildContext context, QueryDocumentSnapshot patientData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title for the patient details section
                const Text(
                  'Patient Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 10),
                // Patient information rows
                _buildDetailRow('Dernier RDV', patientData['Dernier RDV'].isNotEmpty ? patientData['Dernier RDV'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Prochain RDV', patientData['Prochain RDV'].isNotEmpty ? patientData['Prochain RDV'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Group Sanguin', patientData['groupSanguin'].isNotEmpty ? patientData['groupSanguin'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Date Naiss', patientData['dateNaiss'].isNotEmpty ? patientData['dateNaiss'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Age', patientData['age']!.toString().isNotEmpty ? patientData['age'].toString() : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Adresse', patientData['adresse'].isNotEmpty ? patientData['adresse'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Etat Civil', patientData['etatCivil'].isNotEmpty ? patientData['etatCivil'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Genre', patientData['genre'].isNotEmpty ? patientData['genre'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Tel', patientData['tel'].isNotEmpty ? patientData['tel'] : 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Tel WhatsApp', patientData['telWhatsApp'] ?? 'N/A'),
                const SizedBox(height: 8),
                _buildDetailRow('Email', patientData['email'].isNotEmpty ? patientData['email'] : 'N/A'),
                const SizedBox(height: 20),

                // Close button for the modal
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text('Close'),
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
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(value),
        ),
      ],
    );
  }
}
