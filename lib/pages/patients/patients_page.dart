import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = [];
  bool isLoading = true; // Tracks loading state for data fetching

  // Fetch data from Firestore
  Future<void> getData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("patients").get();
      setState(() {
        data = querySnapshot.docs; // Store fetched data
        filteredData = data;       // Set filtered data to show all patients initially
        isLoading = false;          // End loading
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;          // Ensure loading stops on error
      });
    }
  }

  // Filters patient list based on search query
  void filterSearchResults(String query) {
    List<QueryDocumentSnapshot> searchResults = [];
    if (query.isEmpty) {
      searchResults = data;
    } else {
      searchResults = data.where((patient) {
        String name = patient['name'].toString().toLowerCase();
        return name.startsWith(query.toLowerCase());
      }).toList();
    }
    setState(() {
      filteredData = searchResults; // Update filtered data
    });
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data when page loads
    searchController.addListener(() {
      filterSearchResults(searchController.text); // Listen for search query changes
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose controller when page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismisses keyboard on tap outside search bar
        child: RefreshIndicator(
          onRefresh: getData, // Reloads data when user pulls to refresh
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blue,)) // Show loading indicator if data is loading
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
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
              Expanded(
                child: filteredData.isEmpty
                    ? const Center(
                  child: Text(
                    'No Patients',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var patientData = filteredData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.blue),
                          title: Text(
                            '${patientData['name']}${patientData['prenom']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Age: ${patientData['age']}'),
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
          // Add patient action
        },
        icon: const Icon(Icons.add),
        label: const Text('Add patients'),
        backgroundColor: Colors.blueAccent.shade400,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Show details of a specific patient in a Modal bottom sheet
  void _showPatientDetails(BuildContext context, QueryDocumentSnapshot patientData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Set to transparent to remove extra white space around the modal
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Start from half of the screen
          minChildSize: 0.5, // Minimum height of half the screen
          maxChildSize: 0.9, // Maximum height can go up to 90% of the screen
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
                    const Text(
                      'Patient Details',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildDetailRow('CIN', patientData['CIN'].toString().isNotEmpty ? patientData['CIN'].toString() : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Date Naiss', patientData['dateNaiss'].isNotEmpty ? patientData['dateNaiss'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Age', patientData['age'].toString().isNotEmpty ? patientData['age'].toString() : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Genre', patientData['genre'].isNotEmpty ? patientData['genre'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Etat Civil', patientData['etatCivil'].isNotEmpty ? patientData['etatCivil'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Nationalité', patientData['nationalite'].isNotEmpty ? patientData['nationalite'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Adresse', patientData['adresse'].isNotEmpty ? patientData['adresse'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Ville', patientData['ville'].isNotEmpty ? patientData['ville'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Code Postal', patientData['codePostal'].toString().isNotEmpty ? patientData['codePostal'].toString() : 'N/A'),
                    const SizedBox(height: 20),

                  // Contact Information
                    _buildDetailRow('Tel', patientData['tel'].isNotEmpty ? patientData['tel'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Tel WhatsApp', patientData['telWhatsApp'].isNotEmpty ? patientData['telWhatsApp'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Email', patientData['email'].isNotEmpty ? patientData['email'] : 'N/A'),
                    const SizedBox(height: 20),

                  // Medical Information
                    _buildDetailRow('Dernier RDV', patientData['Dernier RDV'].isNotEmpty ? patientData['Dernier RDV'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Prochain RDV', patientData['Prochain RDV'].isNotEmpty ? patientData['Prochain RDV'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Group Sanguin', patientData['groupSanguin'].isNotEmpty ? patientData['groupSanguin'] : 'N/A'),
                    const SizedBox(height: 20),

                  // Insurance Information
                    _buildDetailRow('Numero Assurance', patientData['numeroAssurance'].toString().isNotEmpty ? patientData['numeroAssurance'].toString() : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Assurant', patientData['assurant'].isNotEmpty ? patientData['assurant'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Assurance', patientData['assurance'].isNotEmpty ? patientData['assurance'] : 'N/A'),
                    const SizedBox(height: 20),

                  // Additional Information
                    _buildDetailRow('Relation', patientData['relation'].isNotEmpty ? patientData['relation'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Profession', patientData['profession'].isNotEmpty ? patientData['profession'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Pays', patientData['pays'].isNotEmpty ? patientData['pays'] : 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Adressee par', patientData['adressee'].isNotEmpty ? patientData['adressee'] : 'N/A'),
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close details view
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
      },
    );
  }



  // Helper widget to build each detail row with label and value
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
