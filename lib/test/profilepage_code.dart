import 'package:flutter/material.dart';

import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profilePicture = 'https://via.placeholder.com/150';
  String name = 'Kotti Mahdi';
  String email = 'janedoe@example.com';
  String phone = '+123 456 7890';
  String specialization = 'Cardiologist';
  String bio = 'Experienced cardiologist with over 10 years of practice.';

  final Color primaryColor = const Color(0xFF2A79B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.blueAccent.shade400,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ProfileHeader(
                    profilePicture: profilePicture,
                    name: name,
                    specialization: specialization,
                    onTap: _updateProfilePicture,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InfoSection(
                      email: email,
                      phone: phone,
                      bio: bio,
                    ),
                    const SizedBox(height: 24),
                    ButtonSection(
                      onPressedEdit: _editProfile,
                      onPressedLogout: _logout,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _updateProfilePicture() {
    // Placeholder for image picker integration
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: EditProfileForm(
          name: name,
          email: email,
          phone: phone,
          specialization: specialization,
          bio: bio,
          onSaveChanges: (newName, newEmail, newPhone, newSpecialization, newBio, newProfileImage) {
            setState(() {
              name = newName;
              email = newEmail;
              phone = newPhone;
              specialization = newSpecialization;
              bio = newBio;
              // Optionally handle newProfileImage as needed
            });
            Navigator.pop(context);
          },
        ),

      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String specialization;
  final VoidCallback onTap;

  const ProfileHeader({
    Key? key,
    required this.profilePicture,
    required this.name,
    required this.specialization,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 64,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profilePicture),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt,
                        size: 20, color: Colors.blue.shade800),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          specialization,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class InfoSection extends StatelessWidget {
  final String email;
  final String phone;
  final String bio;

  const InfoSection({
    Key? key,
    required this.email,
    required this.phone,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InfoItem(
              icon: Icons.email_rounded,
              title: 'Email',
              content: email,
              color: Colors.blue.shade800,
            ),
            const Divider(height: 32, color: Colors.grey),
            InfoItem(
              icon: Icons.phone_rounded,
              title: 'Phone',
              content: phone,
              color: Colors.green.shade700,
            ),
            const Divider(height: 32, color: Colors.grey),
            InfoItem(
              icon: Icons.info_outline_rounded,
              title: 'Bio',
              content: bio,
              color: Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const InfoItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonSection extends StatelessWidget {
  final VoidCallback onPressedEdit;
  final VoidCallback onPressedLogout;

  const ButtonSection({
    Key? key,
    required this.onPressedEdit,
    required this.onPressedLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onPressedEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.shade400,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit, size: 20, color: Colors.white),
            label: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onPressedLogout,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.red.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.logout, size: 20),
            label: const Text(
              'Logout',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}


