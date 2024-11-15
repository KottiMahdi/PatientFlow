import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_patient_page.dart';

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode(); // Add FocusNode for the search bar
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = [];
  bool isLoading = true; // Tracks loading state for data fetching

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data when page loads
    searchController.addListener(() {
      filterSearchResults(searchController.text); // Listen for search query changes
    });
    // Add a listener to the FocusNode to rebuild the widget when focus changes
    searchFocusNode.addListener(() {
    setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the FocusNode and TextEditingController
    searchFocusNode.dispose();
    searchController.dispose(); // Dispose controller when page is closed
    super.dispose();
  }

  // Fetches data from Firestore
  Future<void> getData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("patients").get();
      setState(() {
        data = querySnapshot.docs; // Store fetched data
        filteredData = data;       // Set filtered data to show all patients initially
        isLoading = false;         // End loading
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;         // Ensure loading stops on error
      });
    }
  }

  // Filters patient list based on search query
  void filterSearchResults(String query) {
    List<QueryDocumentSnapshot> searchResults = [];
    if (query.isEmpty) {
      searchResults = data; // Show all patients if query is empty
    } else {
      searchResults = data.where((patient) {
        String name = patient['name'].toString().toLowerCase();
        return name.startsWith(query.toLowerCase()); // Search by name prefix
      }).toList();
    }
    setState(() {
      filteredData = searchResults; // Update filtered data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismisses keyboard on tap outside search bar
        child: RefreshIndicator(
          onRefresh: getData, // Reloads data when user pulls to refresh
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blue)) // Show loading indicator if data is loading
              : Column(
            children: [

              // Search bar with back and clear icons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Back icon, shown only when the search bar is focused
                    if (searchFocusNode.hasFocus)
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Colors.blueAccent,
                        onPressed: () {
                          // Unfocus the TextField to hide the keyboard and clear the search
                          searchFocusNode.unfocus();
                          searchController.clear(); // Clear the search input
                          setState(() {}); // Update the UI
                        },
                      ),
                    // Search text field
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        focusNode: searchFocusNode, // Attach the FocusNode to the TextField
                        onChanged: (value) {
                          // Trigger state update to show or hide "X" icon
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear(); // Clear text
                              setState(() {}); // Update the UI to hide "X" icon
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

              // Patient list
              Expanded(
                child: filteredData.isEmpty
                    ? const Center(
                  child: Text(
                    'No Patients',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80.0), // Adds space for the last card to stay above the button
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var patientData = filteredData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
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
                          subtitle: Text('Age: ${patientData['age']} | Assurance: ${patientData['assurance'].isNotEmpty ? patientData['assurance'] : 'N/A'} '),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.blue),
                            onPressed: () {
                              _showPatientDetails(context, patientData); // Show patient details on click
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPatientPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add patients'),
        backgroundColor: Colors.blueAccent.shade400,
        foregroundColor: Colors.white,
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
