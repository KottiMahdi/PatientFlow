import 'package:flutter/material.dart';

class listPatients extends StatefulWidget {
  const listPatients({super.key});

  @override
  State<listPatients> createState() => _listPatientsState();
}

class _listPatientsState extends State<listPatients> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _buildUI(),
    );
  }
  Widget _buildUI() {
    return SafeArea(child: SizedBox.expand(
      child: DataTable(columns: [], rows: []),
    ));

  }
}
