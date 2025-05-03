import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../utils/image_picker_utils.dart';
import 'components/dropDown_specialization.dart';
import 'components/logout_dialog_utils.dart';
import 'components/profile_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  @override
  void initState() {
    super.initState();
    // Load data when widget initializes
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.loadUserData(context);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final theme = Theme.of(context);
        final primaryColor = theme.primaryColor;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFF2A79B0),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: provider.isEditing
                ? IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => provider.toggleEditMode(context),
              tooltip: 'Cancel',
            )
                : null,
            actions: [
              provider.isEditing
                  ? provider.isSaving
                  ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              )
                  : TextButton.icon(
                onPressed: () {
                  if (provider.isFormValid && provider.hasChanges) {
                    provider.saveChanges(context);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Save'),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF2A79B0)),
              )
                  : IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => provider.toggleEditMode(context),
                tooltip: 'Edit Profile',
              ),
            ],
          ),
          body: provider.isLoading
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(height: 16),
                Text(
                  'Loading profile...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          )
              : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey[100]!],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top profile section
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Profile picture
                        Stack(
                          children: [
                            // Circular background
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.2),
                                  width: 3,
                                ),
                                image: provider.profileImage != null
                                    ? DecorationImage(
                                  image: FileImage(
                                      provider.profileImage!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              child: provider.profileImage == null
                                  ? Icon(
                                Icons.person,
                                color:
                                primaryColor.withOpacity(0.8),
                                size: 60,
                              )
                                  : null,
                            ),
                            // Edit button overlay for profile picture
                            if (provider.isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => ImagePickerUtils.showImagePickerBottomSheet(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Name display
                        if (!provider.isEditing)
                          Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  provider.nameController.text,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Display specialization if selected
                              if (provider.selectedSpecialization != null &&
                                  provider.selectedSpecialization!.isNotEmpty)
                                Text(
                                  provider.selectedSpecialization!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Profile details card
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          Row(
                            children: [
                              Icon(Icons.person_outline,
                                  color: primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Profile fields
                          ProfileFieldBuilder.buildProfileField(
                            context,
                            provider,
                            'Full Name',
                            provider.nameController,
                            Icons.person,
                            isRequired: true,
                            isValid:
                            provider.nameController.text.isNotEmpty,
                            errorText: 'Name is required',
                            primaryColor: primaryColor,
                          ),
                          ProfileFieldBuilder.buildProfileField(
                            context,
                            provider,
                            'Email Address',
                            provider.emailController,
                            Icons.email,
                            isRequired: true,
                            isValid: provider.validateEmail(
                                provider.emailController.text),
                            errorText: 'Enter a valid email address',
                            keyboardType: TextInputType.emailAddress,
                            primaryColor: primaryColor,
                            isEditable: false,
                          ),
                          ProfileFieldBuilder.buildProfileField(
                            context,
                            provider,
                            'Phone Number',
                            provider.phoneController,
                            Icons.phone,
                            isRequired: true,
                            isValid: provider.validatePhone(
                                provider.phoneController.text),
                            errorText: 'Enter a valid phone number',
                            keyboardType: TextInputType.phone,
                            primaryColor: primaryColor,
                          ),

                          ProfileDropDownBuilder.buildProfileDropDown(
                            context,
                            provider,
                            "Specialization",
                            provider.selectedSpecialization,
                                (value) => provider.updateSpecialization(value),
                            Icons.medical_services,
                            provider.getDropdownOptions('specializations'), // Ensure correct document ID
                            isRequired: true,
                            primaryColor: Theme.of(context).primaryColor,
                          ),

                          ProfileFieldBuilder.buildProfileField(
                            context,
                            provider,
                            'Professional Bio',
                            provider.bioController,
                            Icons.info_outline,
                            isMultiline: true,
                            primaryColor: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Logout button
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed:() => LogoutDialogUtils.showLogoutDialog(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}