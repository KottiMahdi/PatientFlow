import 'package:flutter/material.dart';

Widget buildTextField(
    BuildContext context,
    String label,
    TextEditingController? controller,
    IconData icon,
    TextInputType inputType) {
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
        prefixIcon: Icon(icon, color: Color(0xFF2A79B0)),
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