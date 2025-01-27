import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPatientPage extends StatefulWidget {
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController codePostalController = TextEditingController();
  final TextEditingController numeroAssuranceController =
      TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  // Additional controllers
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController telWhatsAppController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dernierRdvController = TextEditingController();
  final TextEditingController prochainRdvController = TextEditingController();
  final TextEditingController paysController = TextEditingController();
  final TextEditingController adresseParController = TextEditingController();

// Reference to the "patients" collection in Firestore.
// This allows interaction with the collection to perform CRUD operations
// (Create, Read, Update, Delete) for patient records.
  CollectionReference patients =
  FirebaseFirestore.instance.collection("patients");

  // Dropdown selected values
  String? selectedAssurance;
  String? selectedAssurant;
  String? selectedEtatCivil;
  String? selectedNationalite;
  String? selectedProfession;
  String? selectedRelation;
  String? selectedGroupSanguin;
  String? selectedGenre;



  addPatient() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Safely parse the text inputs into integers
        int? CIN = int.tryParse(cinController.text);
        int? codePostal = int.tryParse(codePostalController.text);
        int? numeroAssurance = int.tryParse(numeroAssuranceController.text);

        // Check if any of the parsed values are null (invalid input)
        if (CIN == null || codePostal == null || numeroAssurance == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Please enter valid numeric values for CIN, Code Postal, and Numero Assurance")),
          );
          return;
        }

        // Organize patient data into a map for Firestore
        Map<String, dynamic> patientData = {
          "name": nameController.text,
          "prenom": prenomController.text,
          "CIN": cinController.text,
          "age": ageController.text,
          "dateNaiss": dateOfBirthController.text,
          "codePostal": codePostalController.text,
          "numeroAssurance": numeroAssuranceController.text,
          "genre": selectedGenre,
          "etatCivil": selectedEtatCivil,
          "nationalite": selectedNationalite,
          "adresse": adresseController.text,
          "ville": villeController.text,
          "tel": telController.text,
          "telWhatsApp": telWhatsAppController.text,
          "email": emailController.text,
          "Dernier RDV": dernierRdvController.text,
          "Prochain RDV": prochainRdvController.text,
          "groupSanguin": selectedGroupSanguin,
          "assurant": selectedAssurant,
          "assurance": selectedAssurance,
          "relation": selectedRelation,
          "profession": selectedProfession,
          "pays": paysController.text,
          "adressee": adresseParController.text,
          "createdAt": FieldValue.serverTimestamp(), // Add timestamp
        };

        // Add the patient's data to Firestore
        await patients.add(patientData);

        // Provide feedback that the patient has been added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Patient added successfully!")),
        );

        // Navigate back to the PatientsPage or close the current screen
        Navigator.pop(
            context); // This will pop the current screen off the stack and return to the previous one
      } catch (e) {
        print("Error: $e");
        // Show an error message in case something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding patient: $e")),
        );
      }
    }
  }

// Function to fetch dropdown options from Firestore for a specific document
// - Retrieves a document from the "dropdown_options" collection
// - Extracts all string values from the document and returns them as a list
// - Handles errors gracefully and returns an empty list in case of failure
  Future<List<String>> getDropdownOptions(String document) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("dropdown_options")
          .doc(document)
          .get();

      if (!snapshot.exists) {
        print("Document does not exist");
        return [];
      }

      // Extract all fields from the document as a list of strings
      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Safely convert fields to a list of strings, assuming the values are either String or List<String>
      return data.values
          .whereType<String>() // Filters out non-string values
          .toList();
    } catch (e) {
      print("Error fetching $document options: $e");
      return []; // Return an empty list on error
    }
  }


  @override
  void dispose() {
    // Dispose of all controllers to prevent memory leaks
    nameController.dispose();
    prenomController.dispose();
    cinController.dispose();
    ageController.dispose();
    codePostalController.dispose();
    numeroAssuranceController.dispose();
    dateOfBirthController.dispose();
    adresseController.dispose();
    villeController.dispose();
    telController.dispose();
    telWhatsAppController.dispose();
    emailController.dispose();
    dernierRdvController.dispose();
    prochainRdvController.dispose();
    paysController.dispose();
    adresseParController.dispose();
    super.dispose();
  }

  // Cache for dropdown data
  Map<String, Future<List<String>>> dropdownCache = {};

  @override
  void initState() {
    super.initState();
    // Preload dropdown options
    dropdownCache['etatCivil'] = getDropdownOptions('etatCivil');
    dropdownCache['nationalite'] = getDropdownOptions('nationalite');
    dropdownCache['assurant'] = getDropdownOptions('assurant');
    dropdownCache['assurance'] = getDropdownOptions('assurance');
    dropdownCache['relation'] = getDropdownOptions('relation');
    dropdownCache['profession'] = getDropdownOptions('profession');
    dropdownCache['groupSanguin'] = getDropdownOptions('groupSanguin');
    dropdownCache['genre'] = getDropdownOptions('genre');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Add Patient", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent.shade400,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.white), // Change the back icon color to white
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Patient Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Input fields in a modern style
                  _buildTextField("First Name", nameController, Icons.person,
                      TextInputType.text),
                  _buildTextField("Last Name", prenomController, Icons.person,
                      TextInputType.text),
                  _buildTextField("CIN", cinController, Icons.perm_identity,
                      TextInputType.number),
                  _buildTextField(
                      "Age", ageController, Icons.cake, TextInputType.text),
                  _buildDateField("Date of Birth", dateOfBirthController),
                  _buildTextField("Code Postale", codePostalController,
                      Icons.location_on, TextInputType.number),
                  _buildTextField("Insurance Number", numeroAssuranceController,
                      Icons.policy, TextInputType.number),

                  Divider(height: 32.0, thickness: 1),

                  // Additional fields with their respective controllers
                  _buildDropdownField(
                      "Genre",
                      "genre",
                      selectedGenre,
                      Icons.transgender,
                          (value) => setState(() => selectedGenre = value)),
                  _buildDropdownField(
                      "Etat Civil",
                      "etatCivil",
                      selectedEtatCivil,
                      Icons.person,
                      (value) => setState(() => selectedEtatCivil = value)),
                  _buildDropdownField(
                      "Nationalité",
                      "nationalite",
                      selectedNationalite,
                      Icons.flag,
                      (value) => setState(() => selectedNationalite = value)),
                  _buildTextField("Adresse", adresseController, Icons.home,
                      TextInputType.streetAddress),
                  _buildTextField("Ville", villeController, Icons.location_city,
                      TextInputType.text),
                  _buildTextField(
                      "Tel", telController, Icons.phone, TextInputType.text),
                  _buildTextField("Tel WhatsApp", telWhatsAppController,
                      Icons.phone_android, TextInputType.text),
                  _buildTextField("Email", emailController, Icons.email,
                      TextInputType.emailAddress),
                  _buildDateField("Dernier RDV", dernierRdvController),
                  _buildDateField("Prochain RDV", prochainRdvController),
                  _buildDropdownField("Group Sanguin", "groupSanguin", selectedGroupSanguin,Icons.water_drop,
                          (value) => setState(() => selectedGroupSanguin = value)),
                  _buildDropdownField("Assurant", "assurant", selectedAssurant,Icons.verified_user,
                      (value) => setState(() => selectedAssurant = value)),
                  _buildDropdownField(
                      "Assurance",
                      "assurance",
                      selectedAssurance,
                      Icons.shield,
                      (value) => setState(() => selectedAssurance = value)),
                  _buildDropdownField("Relation", "relation", selectedRelation,Icons.group,
                      (value) => setState(() => selectedRelation = value)),
                  _buildDropdownField(
                      "Profession",
                      "profession",
                      selectedProfession,
                      Icons.work,
                      (value) => setState(() => selectedProfession = value)),
                  _buildTextField(
                      "Pays", paysController, Icons.public, TextInputType.text),
                  _buildTextField("Adresse par", adresseParController,
                      Icons.location_on, TextInputType.text),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 31, bottom: 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Save the data or perform an action
                  addPatient();
                }
              },
              label: Text("Save"),
              icon: Icon(Icons.save),
              backgroundColor: Colors.blueAccent.shade400,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create modern text fields with icons
  Widget _buildTextField(String label, TextEditingController? controller,
      IconData icon, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Custom date picker field
  Widget _buildDateField(
    String label,
    TextEditingController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          // Set the selected date in the controller or state
          setState(() {
            controller.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
            label, controller, Icons.calendar_today, TextInputType.datetime),
      ),
    );
  }

  Widget _buildDropdownField(String label, String document, String? value,
  IconData icon, Function(String?) onChanged) {
    // Fetch options from cache if available, otherwise load them using `getDropdownOptions`
    dropdownCache.putIfAbsent(document, () => getDropdownOptions(document));

    return FutureBuilder<List<String>>(
      // The FutureBuilder uses this cached Future to directly display
      // the options without re-fetching.
      future: dropdownCache[document],
      builder: (context, snapshot) {
        // Show a loading spinner while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Display an error message if there was an issue loading the data
        if (snapshot.hasError) {
          return Text("Error loading $label options");
        }

        // Build the DropdownButtonFormField if data is successfully fetched
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField<String>(
            // Currently selected value for the dropdown
            value: value,

            // Function to handle changes in selection
            onChanged: onChanged,

            // Create dropdown menu items from the fetched data
            items: snapshot.data!
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      // Prevent text overflow with ellipsis
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
                .toList(),

            // Styling for the dropdown
            decoration: InputDecoration(
              // Label for the dropdown field
              labelText: label,

              // Icon displayed inside the input field
              prefixIcon: Icon(icon, color: Colors.blueAccent),

              // Background color and padding for the input field
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0, // Vertical padding
                horizontal: 12.0, // Horizontal padding
              ),

              // Border styling for the input field
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                borderSide: BorderSide.none, // No visible border
              ),
            ),

            // Dropdown-specific configurations
            isExpanded: true, // Expands dropdown to fit content width
            dropdownColor: Colors.white, // Background color of the dropdown
            icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent), // Updated dropdown icon,
            iconSize: 30, // Size of the dropdown icon
            elevation: 8, // Shadow depth for the dropdown
            style: TextStyle(
                color: Colors.black), // Text style inside the dropdown
          ),
        );
      },
    );
  }
}
