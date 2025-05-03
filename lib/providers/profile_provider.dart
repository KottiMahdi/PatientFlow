import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/build_dopdown_field.dart';

class ProfileState {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController bioController;

  // Changed from TextEditingController to String for specialization
  final String? selectedSpecialization;

  final bool isEditing;
  final bool isSaving;
  final bool hasChanges;
  final bool isLoading;
  final File? profileImage;
  final Map<String, dynamic> originalValues;

  // Added cache for dropdown options
  final Map<String, Future<List<String>>> dropdownCache;

  ProfileState({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.bioController,
    this.selectedSpecialization,
    this.isEditing = false,
    this.isSaving = false,
    this.hasChanges = false,
    this.isLoading = true,
    this.profileImage,
    this.originalValues = const {},
    this.dropdownCache = const {},
  });

  ProfileState copyWith({
    bool? isEditing,
    bool? isSaving,
    bool? hasChanges,
    bool? isLoading,
    File? profileImage,
    Map<String, dynamic>? originalValues,
    String? selectedSpecialization,
    Map<String, Future<List<String>>>? dropdownCache,
  }) {
    return ProfileState(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      bioController: bioController,
      isEditing: isEditing ?? this.isEditing,
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
      isLoading: isLoading ?? this.isLoading,
      profileImage: profileImage ?? this.profileImage,
      originalValues: originalValues ?? this.originalValues,
      selectedSpecialization: selectedSpecialization ?? this.selectedSpecialization,
      dropdownCache: dropdownCache ?? this.dropdownCache,
    );
  }
}

class ProfileProvider extends ChangeNotifier {
  ProfileState _state;

  ProfileProvider()
      : _state = ProfileState(
    nameController: TextEditingController(),
    emailController: TextEditingController(),
    phoneController: TextEditingController(),
    bioController: TextEditingController(),
    dropdownCache: {},
  ) {
    _init();
  }

  // Getters to access state
  ProfileState get state => _state;
  TextEditingController get nameController => _state.nameController;
  TextEditingController get emailController => _state.emailController;
  TextEditingController get phoneController => _state.phoneController;
  TextEditingController get bioController => _state.bioController;

  // New getter for specialization
  String? get selectedSpecialization => _state.selectedSpecialization;

  bool get isEditing => _state.isEditing;
  bool get isSaving => _state.isSaving;
  bool get hasChanges => _state.hasChanges;
  bool get isLoading => _state.isLoading;
  File? get profileImage => _state.profileImage;
  Map<String, dynamic> get originalValues => _state.originalValues;
  Map<String, Future<List<String>>> get dropdownCache => _state.dropdownCache;

  void _init() {
    _addControllerListeners();
  }

  void _addControllerListeners() {
    nameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
    bioController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    if (!_state.isEditing) return;

    bool changed = nameController.text != originalValues['name'] ||
        emailController.text != originalValues['email'] ||
        phoneController.text != originalValues['phone'] ||
        selectedSpecialization != originalValues['specialization'] ||
        bioController.text != originalValues['bio'];

    if (changed != _state.hasChanges) {
      _state = _state.copyWith(hasChanges: changed);
      notifyListeners();
    }
  }

  // New method to update specialization
  void updateSpecialization(String? newSpecialization) {
    _state = _state.copyWith(selectedSpecialization: newSpecialization);
    _checkForChanges();
    notifyListeners();
  }

  void _storeOriginalValues() {
    final newOriginalValues = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'specialization': selectedSpecialization,
      'bio': bioController.text,
    };

    _state = _state.copyWith(originalValues: newOriginalValues);
    notifyListeners();
  }

  // Get dropdown options
// Update in ProfileProvider class
  Future<List<String>> getDropdownOptions(String document) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("dropdown_options")
          .doc(document)
          .get();

      if (!snapshot.exists) return [];

      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Check for 'options' array field
      if (data.containsKey('options') && data['options'] is List) {
        return List<String>.from(data['options']);
      }

      return []; // Fallback if structure is incorrect
    } catch (e) {
      print("Error fetching $document options: $e");
      return [];
    }
  }

  Future<void> loadUserData(BuildContext context) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // Get the current authenticated user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Set email from authentication
        emailController.text = currentUser.email ?? '';

        // Fetch additional user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;

          nameController.text = userData['fullName'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          // Update for specialization dropdown
          String specialization = userData['specialization'] ?? '';
          _state = _state.copyWith(selectedSpecialization: specialization);
          bioController.text = userData['bio'] ?? '';
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      // Show error message to user
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile data. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Store original values after loading
      _storeOriginalValues();

      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

  void toggleEditMode(BuildContext context) {
    if (_state.isEditing && _state.hasChanges) {
      // Ask for confirmation before discarding changes
      showDialog(
        context: context, // Use passed context
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                resetToOriginalValues();
                _state = _state.copyWith(
                  isEditing: false,
                  hasChanges: false,
                );
                notifyListeners();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Discard'),
            ),
          ],
          actionsPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
    } else {
      _state = _state.copyWith(isEditing: !_state.isEditing);
      notifyListeners();
    }
  }

  void resetToOriginalValues() {
    nameController.text = originalValues['name'] ?? '';
    emailController.text = originalValues['email'] ?? '';
    phoneController.text = originalValues['phone'] ?? '';
    _state = _state.copyWith(selectedSpecialization: originalValues['specialization']);
    bioController.text = originalValues['bio'] ?? '';
  }

  Future<void> saveChanges(BuildContext context) async {
    if (!_state.hasChanges) return;

    _state = _state.copyWith(isSaving: true);
    notifyListeners();

    try {
      // Get current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {

        // Print debug info
        print('Saving specialization: $_state.selectedSpecialization');

        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'fullName': nameController.text,
          'phone': phoneController.text,
          'specialization': selectedSpecialization,
          'bio': bioController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update original values after successful save
        _storeOriginalValues();

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error saving profile changes: $e');

      // Show error message
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _state = _state.copyWith(
        isSaving: false,
        isEditing: false,
        hasChanges: false,
      );
      notifyListeners();
    }
  }

  void setProfileImage(File image) {
    _state = _state.copyWith(
      profileImage: image,
      hasChanges: true,
    );
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    // Add context param
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        // Safety check
        Navigator.of(context)
            .pushNamedAndRemoveUntil("login", (route) => false);
      }

    } catch (e) {
      if (context.mounted) {
        // Safety check
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Logged out successfully'),
              ],
            ),
            backgroundColor: Colors.blue[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool validateEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool validatePhone(String phone) {
    return phone.length >= 10;
  }

  bool get isFormValid {
    bool isEmailValid = validateEmail(emailController.text);
    bool isPhoneValid = validatePhone(phoneController.text);
    return isEmailValid && isPhoneValid && nameController.text.isNotEmpty && selectedSpecialization != null;
  }



  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }
}