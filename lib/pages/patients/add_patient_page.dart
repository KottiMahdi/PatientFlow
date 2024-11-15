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
  final TextEditingController numeroAssuranceController = TextEditingController();
  // Add this controller for the date of birth field
  final TextEditingController dateOfBirthController = TextEditingController();

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
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Add Patient", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Change the back icon color to white
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 58.0),
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
                  _buildTextField("Name", nameController, Icons.person, TextInputType.text),
                  _buildTextField("Prenom", prenomController, Icons.person, TextInputType.text),
                  _buildTextField("CIN", cinController, Icons.perm_identity, TextInputType.number),
                  _buildTextField("Age", ageController, Icons.cake, TextInputType.number),
                  _buildDateField("Date of Birth", dateOfBirthController),
                  _buildTextField("Code Postal", codePostalController, Icons.location_on, TextInputType.number),
                  _buildTextField("Numero Assurance", numeroAssuranceController, Icons.policy, TextInputType.number),

                  Divider(height: 32.0, thickness: 1),

                  // Additional fields based on the screenshot
                  _buildTextField("Genre", null, Icons.person_pin_sharp, TextInputType.text),
                  _buildTextField("Etat Civil", null, Icons.people, TextInputType.text),
                  _buildTextField("Nationalité", null, Icons.flag, TextInputType.text),
                  _buildTextField("Adresse", null, Icons.home, TextInputType.streetAddress),
                  _buildTextField("Ville", null, Icons.location_city, TextInputType.text),
                  _buildTextField("Tel", null, Icons.phone, TextInputType.phone),
                  _buildTextField("Tel WhatsApp", null, Icons.phone_android, TextInputType.phone),
                  _buildTextField("Email", null, Icons.email, TextInputType.emailAddress),
                  _buildTextField("Dernier RDV", null, Icons.calendar_today, TextInputType.datetime),
                  _buildTextField("Prochain RDV", null, Icons.calendar_today, TextInputType.datetime),
                  _buildTextField("Group Sanguin", null, Icons.bloodtype, TextInputType.text),
                  _buildTextField("Assurant", null, Icons.account_box, TextInputType.text),
                  _buildTextField("Assurance", null, Icons.verified_user, TextInputType.text),
                  _buildTextField("Relation", null, Icons.family_restroom, TextInputType.text),
                  _buildTextField("Profession", null, Icons.work, TextInputType.text),
                  _buildTextField("Pays", null, Icons.public, TextInputType.text),
                  _buildTextField("Adresse par", null, Icons.location_on, TextInputType.text),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Save the data or perform an action
          }
        },
        label: Text("Save"),
        icon: Icon(Icons.save),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Helper function to create modern text fields with icons
  Widget _buildTextField(String label, TextEditingController? controller, IconData icon, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Custom date picker field
  Widget _buildDateField(String label, TextEditingController controller, ) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          // Set the selected date in the controller or state
          setState(() {
            controller.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(label, controller, Icons.calendar_today, TextInputType.datetime),
      ),
    );
  }
}
