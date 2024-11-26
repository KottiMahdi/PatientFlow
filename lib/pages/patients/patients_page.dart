import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/add_patient_page.dart';
import 'components/show_option_popup.dart';
import 'components/show_patient_details.dart';


// PatientsPage is a StatefulWidget that displays a list of patients
class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController searchController = TextEditingController(); // Controller for the search bar
  final FocusNode searchFocusNode = FocusNode(); // Focus node to manage the search bar focus state
  List<QueryDocumentSnapshot> filteredData = []; // List to store filtered patient data
  String searchQuery = ''; // The query string for search

  @override
  void initState() {
    super.initState();
    // Listen to changes in the search text field
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text; // Update search query on text change
      });
    });
    // Listen to changes in the search bar's focus state
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose(); // Dispose of the focus node when the widget is disposed
    searchController.dispose(); // Dispose of the text controller when the widget is disposed
    super.dispose();
  }

  // Filters patient data based on the search query
  List<QueryDocumentSnapshot> filterSearchResults(
      List<QueryDocumentSnapshot> data) {
    if (searchQuery.isEmpty)
      return data; // Return all patients if the search query is empty
    return data.where((patient) {
      String name = patient['name'].toString().toLowerCase(); // Get the patient's name in lowercase
      return name.startsWith(
          searchQuery.toLowerCase()); // Check if the name starts with the search query
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Patients List', style: TextStyle(color: Colors.white)), // App bar title
        backgroundColor: Colors.blueAccent.shade400, // App bar background color
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss the keyboard when tapping outside
        child: Column(
          children: [
            // Search Bar Widget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Display a back button when the search field is focused
                  if (searchFocusNode.hasFocus)
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black,
                      onPressed: () {
                        searchFocusNode.unfocus(); // Unfocus the search field
                        searchController.clear(); // Clear the search text
                      },
                    ),
                  Expanded(
                    child: TextField(
                      controller: searchController, // Attach the text controller
                      focusNode: searchFocusNode, // Attach the focus node
                      decoration: InputDecoration(
                        hintText: 'Search', // Placeholder text
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search), // Search icon
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear), // Clear icon
                          onPressed: () {
                            searchController.clear(); // Clear the search text
                          },
                        )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none, // Remove border line
                        ),
                        filled: true,
                        fillColor: Colors.grey[200], // Background color of the text field
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Patient List Widget
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("patients") // Fetch the patients collection from Firestore
                    .orderBy("createdAt", descending: true) // Order patients by creation date (descending)
                    .snapshots(), // Listen to real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blueAccent)); // Show loading indicator while waiting
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading data',
                        style: TextStyle(color: Colors.red),
                      ),
                    ); // Display error message if something goes wrong
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Patients',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ); // Show message if no patients are found
                  }

                  final data = snapshot.data!.docs; // Get the patient data from Firestore
                  final filteredData = filterSearchResults(data); // Filter the data based on the search query

                  // Display a list of patients
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    itemCount: filteredData.length, // Number of patients to display
                    itemBuilder: (context, index) {
                      var patientData = filteredData[index]; // Get patient data for this index
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Rounded corners for cards
                          ),
                          child: ListTile(
                            leading: const Icon(
                                Icons.person, color: Colors.blue), // Icon for the patient
                            title: Text(
                              '${patientData['name']} ${patientData['prenom']}', // Patient's name
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold), // Bold text for name
                            ),
                            subtitle: Text(
                                'Assurance: ${patientData['assurance']
                                    .isNotEmpty
                                    ? patientData['assurance']
                                    : 'N/A'} | Age: ${patientData['age']} '), // Patient's insurance and age
                            trailing: IconButton(
                              icon:
                              const Icon(Icons.more_vert, color: Colors.blue), // More options icon
                              onPressed: () {
                                showPatientDetails(context, patientData); // Show patient details
                              },
                            ),
                            onLongPress: () {
                              showOptionsPopup(context, patientData); // Show options popup on long press
                            },
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
      // Floating action button to add a new patient
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 31),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPatientPage()), // Navigate to the AddPatientPage
                );
              },
              icon: const Icon(Icons.add), // Add icon
              label: const Text('Add'), // Label for the button
              backgroundColor: Colors.blueAccent.shade400, // Background color
              foregroundColor: Colors.white, // Text and icon color
            ),
          ],
        ),
      ),
    );
  }

  // This function would handle editing a patient's data (not implemented in this code)
  void _editPatient(BuildContext context, Map<String, dynamic> patientData) {
    // Navigate to the edit form or handle edit logic here
  }
}
