import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/add_patient_page.dart';

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  List<QueryDocumentSnapshot> filteredData = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text; // Update search query
      });
    });
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Filters patient data based on the search query
  List<QueryDocumentSnapshot> filterSearchResults(
      List<QueryDocumentSnapshot> data) {
    if (searchQuery.isEmpty) return data; // Show all patients if search is empty
    return data.where((patient) {
      String name = patient['name'].toString().toLowerCase();
      return name.startsWith(searchQuery.toLowerCase()); // Search by name prefix
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent.shade400,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (searchFocusNode.hasFocus)
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () {
                        searchFocusNode.unfocus();
                        searchController.clear();
                      },
                    ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Patient List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("patients")
                    .orderBy("createdAt", descending: true)
                    .snapshots(), // Listen to real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blueAccent));
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading data',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Patients',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final data = snapshot.data!.docs;
                  final filteredData = filterSearchResults(data);

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var patientData = filteredData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.blue),
                            title: Text(
                              '${patientData['name']} ${patientData['prenom']}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'Assurance: ${patientData['assurance'].isNotEmpty ? patientData['assurance'] : 'N/A'} | Age: ${patientData['age']} '),
                            trailing: IconButton(
                              icon:
                              const Icon(Icons.more_vert, color: Colors.blue),
                              onPressed: () {
                                _showPatientDetails(context, patientData);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 31),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPatientPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              backgroundColor: Colors.blueAccent.shade400,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

// Function to Show details of a specific patient in a Modal bottom sheet
  void _showPatientDetails(BuildContext context, QueryDocumentSnapshot patientData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Set to transparent to remove extra white space around the modal
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Start from half of the screen
          minChildSize: 0.5,     // Minimum height of half the screen
          maxChildSize: 0.9,     // Maximum height can go up to 90% of the screen
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                controller: scrollController, // Attach the scroll controller
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        '${patientData['name']} ${patientData['prenom']}',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Personal Information
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

                    // Contact Information
                    _buildSectionHeader('Contact Information'),
                    _buildDetailRow('Tel', patientData['tel'].isNotEmpty ? patientData['tel'] : 'N/A'),
                    _buildDetailRow('Tel WhatsApp', patientData['telWhatsApp'].isNotEmpty ? patientData['telWhatsApp'] : 'N/A'),
                    _buildDetailRow('Email', patientData['email'].isNotEmpty ? patientData['email'] : 'N/A'),

                    const SizedBox(height: 20),

                    // Medical Information
                    _buildSectionHeader('Medical Information'),
                    _buildDetailRow('Dernier RDV', patientData['Dernier RDV'].isNotEmpty ? patientData['Dernier RDV'] : 'N/A'),
                    _buildDetailRow('Prochain RDV', patientData['Prochain RDV'].isNotEmpty ? patientData['Prochain RDV'] : 'N/A'),
                    _buildDetailRow('Group Sanguin', patientData['groupSanguin'].isNotEmpty ? patientData['groupSanguin'] : 'N/A'),

                    const SizedBox(height: 20),

                    // Insurance Information
                    _buildSectionHeader('Insurance Information'),
                    _buildDetailRow('Numero Assurance', patientData['numeroAssurance'].toString().isNotEmpty ? patientData['numeroAssurance'].toString() : 'N/A'),
                    _buildDetailRow('Assurant', patientData['assurant'].isNotEmpty ? patientData['assurant'] : 'N/A'),
                    _buildDetailRow('Assurance', patientData['assurance'].isNotEmpty ? patientData['assurance'] : 'N/A'),

                    const SizedBox(height: 20),

                    // Additional Information
                    _buildSectionHeader('Additional Information'),
                    _buildDetailRow('Relation', patientData['relation'].isNotEmpty ? patientData['relation'] : 'N/A'),
                    _buildDetailRow('Profession', patientData['profession'].isNotEmpty ? patientData['profession'] : 'N/A'),
                    _buildDetailRow('Pays', patientData['pays'].isNotEmpty ? patientData['pays'] : 'N/A'),
                    _buildDetailRow('Adressee par', patientData['adressee'].isNotEmpty ? patientData['adressee'] : 'N/A'),

                    const SizedBox(height: 20),

                    // Close button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close details view
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        mainAxisAlignment: MainAxisAlignment.start, // Aligns children at the start (left)
        children: [
          // Label text, e.g., "Name: "
          Text(
            '$label: ', // The label (like "Name") with a colon
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
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
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }
}
