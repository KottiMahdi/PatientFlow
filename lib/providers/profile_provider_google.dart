import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/image_picker_utils.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // Cached values for checking changes
  String _cachedName = '';
  String _cachedEmail = '';
  String _cachedPhone = '';
  String _cachedBio = '';
  String? _cachedSpecialization;

  // State variables
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  String? _selectedSpecialization;

  // Getters
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  bool get isSaving => _isSaving;
  String? get selectedSpecialization => _selectedSpecialization;

  // Check if any changes were made
  bool get hasChanges {
    return nameController.text != _cachedName ||
        emailController.text != _cachedEmail ||
        phoneController.text != _cachedPhone ||
        bioController.text != _cachedBio ||
        _selectedSpecialization != _cachedSpecialization;
  }

  // Check if form is valid
  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        validateEmail(emailController.text) &&
        validatePhone(phoneController.text) &&
        _selectedSpecialization != null &&
        _selectedSpecialization!.isNotEmpty;
  }

  // Load user data
  Future<void> loadUserData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userData = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;

        // Set values with fallbacks
        nameController.text = data['fullName'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        bioController.text = data['bio'] ?? '';
        _selectedSpecialization = data['specialization'];

        // Cache values for comparison
        _cacheCurrentValues();
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Toggle edit mode
  void toggleEditMode(BuildContext context) {
    if (_isEditing) {
      // Exit edit mode and reset to cached values
      _resetToCache();
    } else {
      // Enter edit mode and cache current values
      _cacheCurrentValues();
    }

    _isEditing = !_isEditing;
    notifyListeners();
  }

  // Cache current values for comparison and reset
  void _cacheCurrentValues() {
    _cachedName = nameController.text;
    _cachedEmail = emailController.text;
    _cachedPhone = phoneController.text;
    _cachedBio = bioController.text;
    _cachedSpecialization = _selectedSpecialization;
  }

  // Reset values to cached state (cancel edit)
  void _resetToCache() {
    nameController.text = _cachedName;
    emailController.text = _cachedEmail;
    phoneController.text = _cachedPhone;
    bioController.text = _cachedBio;
    _selectedSpecialization = _cachedSpecialization;
  }

  // Save changes to Firebase
  Future<void> saveChanges(BuildContext context) async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the form errors')),
      );
      return;
    }

    _isSaving = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('users').doc(user.uid).update({
        'fullName': nameController.text,
        'phone': phoneController.text,
        'bio': bioController.text,
        'specialization': _selectedSpecialization,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update cache after successful save
      _cacheCurrentValues();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      // Exit edit mode
      _isEditing = false;
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Update specialization value
  void updateSpecialization(String? value) {
    _selectedSpecialization = value;
    notifyListeners();
  }

  // Validation methods
  bool validateEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePhone(String phone) {
    if (phone.isEmpty) return false;
    // Simple phone validation - adjust as needed for your region
    return phone.length >= 8;
  }

  // Get dropdown options from Firestore
  Future<List<String>> getDropdownOptions(String document) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection("dropdown_options")
          .doc(document)
          .get();

      if (!snapshot.exists) {
        // If document doesn't exist, return a default value
        return ["Not specified"];
      }

      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> options = data.values.whereType<String>().toList();

      // Ensure the list has at least the default value
      if (options.isEmpty) {
        options.add("Not specified");
      }

      // Make sure current selected value is in the options list
      if (_selectedSpecialization != null &&
          _selectedSpecialization!.isNotEmpty &&
          !options.contains(_selectedSpecialization)) {
        options.add(_selectedSpecialization!);
      }

      return options;
    } catch (e) {
      print("Error fetching $document options: $e");
      // Return at least the default option on error
      return ["Not specified"];
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }
}