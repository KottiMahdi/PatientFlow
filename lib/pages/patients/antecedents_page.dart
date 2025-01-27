// Import necessary packages
import 'package:flutter/material.dart'; // For Flutter's Material Design widgets
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database interactions

// Define a StatefulWidget for the AntecedentsPage
class AntecedentsPage extends StatefulWidget {
  final String patientId; // Pass the patient's ID to this page

  // Constructor to accept the patientId
  AntecedentsPage({required this.patientId});

  @override
  _AntecedentsPageState createState() => _AntecedentsPageState(); // Create the state for this widget
}

// Define the state for the AntecedentsPage
class _AntecedentsPageState extends State<AntecedentsPage> {
  // List of predefined categories for antecedents
  final List<String> categories = [
    'Antécédents obstétricaux',
    'Antécédents gynécologiques',
    'Antécédents menstruels',
    'Antécédents familiaux',
    'Antécédents médicaux',
    'Antécédents chirurgicaux',
    'Facteurs de risque',
    'Allergique',
  ];

  // Map to store items for each category
  Map<String, List<String>> categoryItems = {
    'Antécédents obstétricaux': [],
    'Antécédents gynécologiques': [],
    'Antécédents menstruels': [],
    'Antécédents familiaux': [],
    'Antécédents médicaux': [],
    'Antécédents chirurgicaux': [],
    'Facteurs de risque': [],
    'Allergique': [],
  };

  @override
  void initState() {
    super.initState();
    fetchPatientAntecedents(); // Fetch antecedents for the specific patient when the widget is initialized
  }

  // Fetch antecedents for the specific patient from Firestore
  void fetchPatientAntecedents() async {
    // Fetch the patient's document from Firestore using the patientId
    final patientDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.patientId)
        .get();

    // Check if the document exists
    if (patientDoc.exists) {
      // Extract the 'antecedents' field from the document, defaulting to an empty map if null
      final antecedents = patientDoc.data()?['antecedents'] as Map<String, dynamic>? ?? {};

      // Update the state with the fetched antecedents
      setState(() {
        // Populate categoryItems with the patient's antecedents
        for (var category in categories) {
          categoryItems[category] = List<String>.from(antecedents[category] ?? []);
        }
      });
    }
  }

  // Save antecedents to Firestore for the specific patient
  void savePatientAntecedents() async {
    // Update the 'antecedents' field in the patient's document with the current categoryItems
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.patientId)
        .update({
      'antecedents': categoryItems,
    });
  }

  // Helper function to convert category name to Firestore document key
  String _getDocumentKey(String category) {
    // Convert a category name to a Firestore document key
    switch (category) {
      case 'Antécédents obstétricaux':
        return 'obstetricaux';
      case 'Antécédents gynécologiques':
        return 'gynecologiques';
      case 'Antécédents menstruels':
        return 'menstruels';
      case 'Antécédents familiaux':
        return 'familiaux';
      case 'Antécédents médicaux':
        return 'medicaux';
      case 'Antécédents chirurgicaux':
        return 'chirurgicaux';
      case 'Facteurs de risque':
        return 'facteurs_de_risque';
      case 'Allergique':
        return 'allergique';
      default:
        return '';
    }
  }

  // Function to fetch dropdown options from Firestore for a specific document
  Future<List<String>> getAntecedentsOptions(String document) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("antecedents")
          .doc(document)
          .get();

      // Check if the document exists
      if (!snapshot.exists) {
        print("Document does not exist");
        return []; // Return an empty list if the document doesn't exist
      }

      // Extract all fields from the document as a map
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Safely convert fields to a list of strings, filtering out non-string values
      return data.values
          .whereType<String>() // Filters out non-string values
          .toList();
    } catch (e) {
      // Handle errors and return an empty list
      print("Error fetching $document options: $e");
      return [];
    }
  }

  // Show a dialog to add an item to a category
  void _showAddItemDialog(String category) async {
    String? selectedItem; // Variable to hold the selected dropdown value

    // Fetch dropdown options from Firestore when the dialog is opened
    final documentKey = _getDocumentKey(category);
    final dropdownOptions = await getAntecedentsOptions(documentKey);

    // Display the dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Item to $category"), // Dialog title
        content: StatefulBuilder(builder: (context, setState) {
          return DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text("Select an item"), // Dropdown hint text
            items: dropdownOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option), // Display each dropdown option
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedItem = value; // Update the selected item
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(), // Styling for the dropdown
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          );
        }),
        actions: [
          // Cancel button to close the dialog
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          // Add button to add the selected item
          TextButton(
            onPressed: () {
              if (selectedItem != null) {
                setState(() {
                  categoryItems[category]!.add(selectedItem!); // Add the selected item to the category
                });
                savePatientAntecedents(); // Save the updated antecedents to Firestore
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Antécédents'), // App bar title
        backgroundColor: Colors.blueAccent.shade400, // App bar background color
        foregroundColor: Colors.white, // App bar text color
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10), // Padding for the list
        itemCount: categories.length, // Number of categories
        itemBuilder: (context, index) {
          final category = categories[index]; // Current category
          final items = categoryItems[category]!; // Items for the current category
          return Card(
            elevation: 2, // Card elevation for shadow
            margin: EdgeInsets.symmetric(vertical: 8), // Card margin
            child: ExpansionTile(
              leading: IconButton(
                icon: Icon(Icons.add, color: Colors.green), // Add button icon
                onPressed: () => _showAddItemDialog(category), // Open the add item dialog
              ),
              title: Text(
                category,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Category title style
              ),
              initiallyExpanded: true, // Expand the tile by default
              children: [
                // Display each item in the category
                ...items.map(
                      (item) => ListTile(
                    title: Text(item), // Item text
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red), // Delete button icon
                      onPressed: () {
                        setState(() {
                          items.remove(item); // Remove the item from the list
                        });
                        savePatientAntecedents(); // Save the updated antecedents to Firestore
                      },
                    ),
                  ),
                ),
                // Display a message if no items are added yet
                if (items.isEmpty)
                  ListTile(
                    title: Text(
                      "No items added yet",
                      style: TextStyle(color: Colors.grey), // Grey text for empty state
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}