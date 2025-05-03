import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/profile_provider.dart';

class LogoutDialogUtils {
  static void showLogoutDialog(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    // Show confirmation dialog before logging out
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
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
              provider.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2A79B0),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
        actionsPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}