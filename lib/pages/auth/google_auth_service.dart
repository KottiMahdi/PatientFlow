import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleAuthService {
  //--------------Sign in with Google--------------
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      print("Starting Google Sign In process");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /* if user click sign in with google and then cancel with this code will
      stop the rest of this function sign in with google */
      if (googleUser == null) {
        print("Google Sign In was canceled by user");
        return;
      }

      print("Google Sign In successful for: ${googleUser.email}");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      print("Obtained Google authentication");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print("Created Google Auth credential");

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print("Firebase sign-in successful for user: ${userCredential.user?.email}");

      // Check if this is a new user
      final User user = userCredential.user!;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // This is a new user, add them to the users collection
        await addUserToFirestore(user);
        print("New user added to Firestore database");
      } else {
        print("Existing user found in database");
      }

      // Add a small delay before navigation to ensure Firebase operations complete
      await Future.delayed(Duration(milliseconds: 500));

      print("Attempting navigation to homepage");
      Navigator.of(context).pushNamedAndRemoveUntil('navigationBar', (route) => false);
      print("Navigation should have occurred");
    } catch (e) {
      print("Error in Google Sign In: $e");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign in failed: ${e.toString()}")),
      );
    }
  }

  // Helper method to add user details to Firestore
  static Future<void> addUserToFirestore(User user) async {
    try {
      // Get specialization options from Firestore to ensure we use a valid default value
      final specializations = await getSpecializationOptions();
      String defaultSpecialization = "Not specified yet";

      // Use the first specialization as default if available, otherwise use "Not specified"
      if (specializations.isEmpty) {
        defaultSpecialization = specializations.first;
      }

      // Extract user information from Google Sign In
      final String? displayName = user.displayName;
      final String? email = user.email;
      final String? phoneNumber = user.phoneNumber; // May be null from Google Auth

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'fullName': displayName ?? 'Google User',
        'email': email ?? '',
        'phone': phoneNumber ?? 'Not provided yet', // Better default for phone number
        'specialization': defaultSpecialization, // Using validated default value
        'bio': 'Not provided yet', // Default bio similar to phone number
        'createdAt': FieldValue.serverTimestamp(),
        'authProvider': 'google',
      });
    } catch (e) {
      print("Error adding user to Firestore: $e");
      throw e; // Re-throw to be caught by the calling method
    }
  }

  // Helper method to get specialization options
  static Future<List<String>> getSpecializationOptions() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("dropdown_options")
          .doc("specialization")
          .get();

      if (!snapshot.exists) {
        // If document doesn't exist, return a default list with at least "Not specified"
        return ["Not specified"];
      }

      final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> options = data.values.whereType<String>().toList();

      // Make sure our list has at least one value
      if (options.isEmpty) {
        options.add("Not specified");
      }

      return options;
    } catch (e) {
      print("Error fetching specialization options: $e");
      // Return a default value on error
      return ["Not specified"];
    }
  }
}