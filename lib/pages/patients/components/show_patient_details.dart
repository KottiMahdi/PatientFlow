import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to Show Details of a Specific Patient in a Modal Bottom Sheet
void showPatientDetails(BuildContext context, QueryDocumentSnapshot patientData) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the modal to occupy more space
    backgroundColor: Colors.transparent, // Set transparent background
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6, // Initial height of the modal (60% of screen)
        minChildSize: 0.5, // Minimum height of the modal (50% of screen)
        maxChildSize: 0.9, // Maximum height of the modal (90% of screen)
        builder: (BuildContext context, ScrollController scrollController) {
          return Stack(
            children: [
              // Main Container for the Modal Content
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Modal background color
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20), // Rounded corners at the top
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20.0, top: 20.0, right: 20.0, bottom: 80.0,
                ), // Padding for content
                child: SingleChildScrollView(
                  controller: scrollController, // Attach scroll controller
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Patient Name
                      Center(
                        child: Text(
                          '${patientData['name']} ${patientData['prenom']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A79B0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Personal Information Section
                      _buildSectionHeader('Personal Information'),
                      _buildDetailRow('CIN', patientData['CIN'].toString().isNotEmpty ? patientData['CIN'].toString() : 'N/A'),
                      _buildDetailRow('Date Naiss', patientData['dateNaiss'].isNotEmpty ? patientData['dateNaiss'] : 'N/A'),
                      _buildDetailRow('Age', patientData['age'].toString().isNotEmpty ? patientData['age'].toString() : 'N/A'),
                      _buildDetailRow('Genre', patientData['genre'].isNotEmpty ? patientData['genre'] : 'N/A'),
                      _buildDetailRow('Etat Civil', patientData['etatCivil'].isNotEmpty ? patientData['etatCivil'] : 'N/A'),
                      _buildDetailRow('Nationalité', patientData['nationalite'].isNotEmpty ? patientData['nationalite'] : 'N/A'),
                      _buildDetailRow('Adresse', patientData['adresse'].isNotEmpty ? patientData['adresse'] : 'N/A'),
                      _buildDetailRow('Ville', patientData['ville'].isNotEmpty ? patientData['ville'] : 'N/A'),
                      _buildDetailRow('Code Postal', patientData['codePostal'].toString().isNotEmpty ? patientData['codePostal'].toString() : 'N/A'),

                      const SizedBox(height: 20),

                      // Contact Information Section
                      _buildSectionHeader('Contact Information'),
                      _buildDetailRow('Tel', patientData['tel'].isNotEmpty ? patientData['tel'] : 'N/A'),
                      _buildDetailRow('Tel WhatsApp', patientData['telWhatsApp'].isNotEmpty ? patientData['telWhatsApp'] : 'N/A'),
                      _buildDetailRow('Email', patientData['email'].isNotEmpty ? patientData['email'] : 'N/A'),

                      const SizedBox(height: 20),

                      // Medical Information Section
                      _buildSectionHeader('Medical Information'),
                      _buildDetailRow('Dernier RDV', patientData['Dernier RDV'].isNotEmpty ? patientData['Dernier RDV'] : 'N/A'),
                      _buildDetailRow('Prochain RDV', patientData['Prochain RDV'].isNotEmpty ? patientData['Prochain RDV'] : 'N/A'),
                      _buildDetailRow('Group Sanguin', patientData['groupSanguin'].isNotEmpty ? patientData['groupSanguin'] : 'N/A'),

                      const SizedBox(height: 20),

                      // Insurance Information Section
                      _buildSectionHeader('Insurance Information'),
                      _buildDetailRow('Numero Assurance', patientData['numeroAssurance'].toString().isNotEmpty ? patientData['numeroAssurance'].toString() : 'N/A'),
                      _buildDetailRow('Assurant', patientData['assurant'].isNotEmpty ? patientData['assurant'] : 'N/A'),
                      _buildDetailRow('Assurance', patientData['assurance'].isNotEmpty ? patientData['assurance'] : 'N/A'),

                      const SizedBox(height: 20),

                      // Additional Information Section
                      _buildSectionHeader('Additional Information'),
                      _buildDetailRow('Relation', patientData['relation'].isNotEmpty ? patientData['relation'] : 'N/A'),
                      _buildDetailRow('Profession', patientData['profession'].isNotEmpty ? patientData['profession'] : 'N/A'),
                      _buildDetailRow('Pays', patientData['pays'].isNotEmpty ? patientData['pays'] : 'N/A'),
                      _buildDetailRow('Adressee par', patientData['adressee'].isNotEmpty ? patientData['adressee'] : 'N/A'),
                    ],
                  ),
                ),
              ),

              // Floating "Close" Button
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.5 - 30, // Center the button horizontally
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                  backgroundColor: Color(0xFF2A79B0),
                  label: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

// Helper widget to build each detail row with label and value
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      // Aligns children at the start (left)
      children: [
        // Label text, e.g., "Name: "
        Text(
          '$label: ', // The label (like "Name") with a colon
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.grey),
        ),

        // Flexible widget to allow the value to take up the remaining space
        Flexible(
          child: Text(
            value, // The value (e.g., "John Doe")
            style: const TextStyle(color: Colors.black87),

            // If the text overflows, show an ellipsis ("...") at the end
            overflow: TextOverflow.ellipsis,

            // Align the value text to the end (right side) of the available space
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}


// Helper widget to build section header with background color and padding
Widget _buildSectionHeader(String title) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    decoration: BoxDecoration(
      color: Color(0xFF2A79B0).withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2A79B0)),
    ),
  );
}
