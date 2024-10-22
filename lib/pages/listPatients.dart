import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/data.dart'; // Importing data containing 'patients' list and 'patients' class

// Stateful widget for displaying a list of patients
class ListPatients extends StatefulWidget {
  const ListPatients({super.key});

  @override
  State<ListPatients> createState() => _ListPatientsState();
}

// State class that handles the UI and logic for sorting and displaying patient data
class _ListPatientsState extends State<ListPatients> {
  // List of patients, initialized from the imported data
  final List<patients> _data = List.from(coins);

  // Boolean to track sorting order (ascending or descending)
  bool _isSortAsc = true;

  @override
  Widget build(BuildContext context) {
    // Building the main UI with a Scaffold
    return Scaffold(
      body: _buildUI(), // Calls the helper method to build the UI
    );
  }

  // Helper method to build the entire UI
  Widget _buildUI() {
    return SafeArea(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Enables vertical scrolling
          child: DataTable(
            columns: _createColumns(), // Creates the table columns
            rows: _createRows(), // Creates the table rows with data
          ),
        ),
      ),
    );
  }

  // Method to create the table columns, with sorting functionality for the "Name" column
  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text("Id")), // Column for patient ID
      DataColumn(
        label: const Text("Name"),
        onSort: (columnIndex, _) {
          // Sorting functionality for the "Name" column
          setState(() {
            if (_isSortAsc) {
              _data.sort((a, b) => a.name.compareTo(b.name)); // Sort ascending
            } else {
              _data.sort((a, b) => b.name.compareTo(a.name)); // Sort descending
            }
            _isSortAsc = !_isSortAsc; // Toggle sorting order
          });
        },
      ),
      const DataColumn(label: Text("Dernier_RDV")), // Column for the patient's last appointment (Dernier RDV)
    ];
  }

  // Method to map the patient data into table rows
  List<DataRow> _createRows() {
    return _data.map((e) {
      // For each patient, create a DataRow with corresponding DataCells
      return DataRow(
        cells: [
          DataCell(Text(e.id.toString())), // Display patient ID
          DataCell(Text(e.name.toString())), // Display patient name
          DataCell(Text(e.Dernier_RDV.toString())), // Display last appointment date
        ],
      );
    }).toList();
  }
}
