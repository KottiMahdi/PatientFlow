import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/patients_page.dart';

import '../navigation_bar.dart';

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
  final TextEditingController genreController = TextEditingController();
  final TextEditingController etatCivilController = TextEditingController();
  final TextEditingController nationaliteController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController telWhatsAppController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dernierRdvController = TextEditingController();
  final TextEditingController prochainRdvController = TextEditingController();
  final TextEditingController groupeSanguinController = TextEditingController();
  final TextEditingController assurantController = TextEditingController();
  final TextEditingController assuranceController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController paysController = TextEditingController();
  final TextEditingController adresseParController = TextEditingController();

  CollectionReference patients =
      FirebaseFirestore.instance.collection("patients");

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
            SnackBar(content: Text("Please enter valid numeric values for CIN, Code Postal, and Numero Assurance")),
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
          "genre": genreController.text,
          "etatCivil": etatCivilController.text,
          "nationalite": nationaliteController.text,
          "adresse": adresseController.text,
          "ville": villeController.text,
          "tel": telController.text,
          "telWhatsApp": telWhatsAppController.text,
          "email": emailController.text,
          "Dernier RDV": dernierRdvController.text,
          "Prochain RDV": prochainRdvController.text,
          "groupSanguin": groupeSanguinController.text,
          "assurant": assurantController.text,
          "assurance": assuranceController.text,
          "relation": relationController.text,
          "profession": professionController.text,
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
        Navigator.pop(context);  // This will pop the current screen off the stack and return to the previous one

      } catch (e) {
        print("Error: $e");
        // Show an error message in case something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding patient: $e")),
        );
      }
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
    genreController.dispose();
    etatCivilController.dispose();
    nationaliteController.dispose();
    adresseController.dispose();
    villeController.dispose();
    telController.dispose();
    telWhatsAppController.dispose();
    emailController.dispose();
    dernierRdvController.dispose();
    prochainRdvController.dispose();
    groupeSanguinController.dispose();
    assurantController.dispose();
    assuranceController.dispose();
    relationController.dispose();
    professionController.dispose();
    paysController.dispose();
    adresseParController.dispose();
    super.dispose();
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
                  _buildTextField("Genre", genreController,
                      Icons.person_pin_sharp, TextInputType.text),
                  _buildTextField("Etat Civil", etatCivilController,
                      Icons.people, TextInputType.text),
                  _buildTextField("Nationalité", nationaliteController,
                      Icons.flag, TextInputType.text),
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
                  _buildTextField("Group Sanguin", groupeSanguinController,
                      Icons.bloodtype, TextInputType.text),
                  _buildTextField("Assurant", assurantController,
                      Icons.account_box, TextInputType.text),
                  _buildTextField("Assurance", assuranceController,
                      Icons.verified_user, TextInputType.text),
                  _buildTextField("Relation", relationController,
                      Icons.family_restroom, TextInputType.text),
                  _buildTextField("Profession", professionController,
                      Icons.work, TextInputType.text),
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
}
