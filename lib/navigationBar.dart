import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/pages/agenda_page.dart';
import 'package:management_cabinet_medical_mobile/pages/Salle_dattente_page.dart';
import 'package:management_cabinet_medical_mobile/pages/home_page.dart';
import 'package:management_cabinet_medical_mobile/pages/patients_page.dart';

class navigationbar extends StatefulWidget {
  const navigationbar({super.key});

  @override
  State<navigationbar> createState() => _navigationbarState();
}

class _navigationbarState extends State<navigationbar> {
  // Create a PageController to control the PageView
  final PageController _pageController = PageController();
  // Variable to store the current index of the page
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Prevents the layout from being affected by the keyboard opening
        resizeToAvoidBottomInset: false,
        // The body of the app uses a PageView to display pages with swipeable navigation
        body: PageView(
          controller: _pageController,
          physics: const ScrollPhysics(), // Controls how pages can be scrolled
          onPageChanged: (index) {
            setState(() {
              _currentIndex =
                  index; // Update the current index when page changes
            });
          },
          children: <Widget>[
            const HomePage(),
            PatientsPage(),
            AgendaPage(),
            const SalleDattentePage(),

            // Displays the HomePage widget as the first page
          ],
        ),

        // Bottom Navigation Bar with different items for navigation
        bottomNavigationBar: BottomNavigationBar(
          // Display all labels
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          // Set the current index to sync with the page
          unselectedItemColor: Colors.grey,
          // Color for unselected items
          selectedItemColor: Colors.blue,
          // Color for selected items
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, // Bold style for the selected label
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the index when tapped
              _pageController.animateToPage(
                index, // Navigate to the selected page
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: [
            // First BottomNavigationBarItem with an image as the icon
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                // Padding for the image icon
                child: Image.asset(
                  'assets/images/home.png', // Path to the image asset
                  fit: BoxFit.contain, // Ensures image fits well
                  width: 25, // Image width
                ),
              ),
              label: "Home", // Label for the first navigation item
            ),

            // Other items with icons
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                // Padding for the image icon
                child: Image.asset(
                  'assets/images/people.png', // Path to the image asset
                  fit: BoxFit.contain, // Ensures image fits well
                  width: 25, // Image width
                ),
              ), // Icon for "Patients"
              label: "Patients",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                // Padding for the image icon
                child: Image.asset(
                  'assets/images/calendar.png', // Path to the image asset
                  fit: BoxFit.contain, // Ensures image fits well
                  width: 25, // Image width
                ),
              ), // Icon for "RDV" (Appointments)
              label: "Agenda",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                // Padding for the image icon
                child: Image.asset(
                  'assets/images/hourglass.png', // Path to the image asset
                  fit: BoxFit.contain, // Ensures image fits well
                  width: 25, // Image width
                ),
              ), // Icon for "Attente" (Waiting)
              label: "Attente",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                // Padding for the image icon
                child: Image.asset(
                  'assets/images/cogwheel.png', // Path to the image asset
                  fit: BoxFit.contain, // Ensures image fits well
                  width: 25, // Image width
                ),
              ), // Icon for "Settings"
              label: "Settings",
            ),
          ],
        ),

        // App bar at the top with the title of the app
        appBar: AppBar(
          title:
              const Text("Management Medical Office"), // Title for the app bar
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller when done
    super.dispose();
  }
}
