import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/pages/agenda/agenda_page.dart';
import 'package:management_cabinet_medical_mobile/pages/attente/Salle_dattente_page.dart';
import 'package:management_cabinet_medical_mobile/pages/home_page.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/patients_page.dart';

// Define a StatefulWidget class for the navigation bar
class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _NavigationBarState();
}

// Define the State class for managing the navigation bar's state
class _NavigationBarState extends State<navigationBar> {
  // PageController to control page navigation and handle animations between pages
  final PageController _pageController = PageController();
  int _currentIndex = 0; // Keeps track of the current tab index

  @override
  Widget build(BuildContext context) {
    // Dynamically adjust font size based on screen width for responsiveness
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth > 360 ? 12 : 10;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Prevents bottom inset from resizing the widget tree
        body: PageView(
          controller: _pageController, // Links PageView with PageController
          physics: const ScrollPhysics(), // Sets physics for scrolling
          onPageChanged: (index) { // Called when user changes page
            setState(() {
              _currentIndex = index; // Update the current tab index
            });
          },
          children: <Widget>[
            const HomePage(), // Home page
            PatientsPage(), // Patients page
            AgendaPage(), // Appointments page
            const SalleDattentePage(), // Waiting room page
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Keeps items in place without shifting
          currentIndex: _currentIndex, // Sets the current selected index
          unselectedItemColor: Colors.grey, // Color for unselected icons
          selectedItemColor: Colors.blue, // Color for selected icon
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold, // Bold label for selected tab
            fontSize: fontSize, // Set font size for selected label
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: fontSize - 1, // Slightly smaller font for unselected labels
          ),
          onTap: (index) { // Triggered when a tab is tapped
            setState(() {
              _currentIndex = index; // Update the current index
              _pageController.animateToPage(
                index, // Move to the selected page
                duration: const Duration(milliseconds: 300), // Duration of transition
                curve: Curves.easeInOut, // Animation curve for smooth transition
              );
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0), // Adds padding above the icon
                child: Icon(Icons.home), // Home icon
              ),
              label: "Home", // Label for Home tab
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.group), // Patients icon
              ),
              label: "Patients", // Label for Patients tab
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.event), // Appointments icon
              ),
              label: "Appointments", // Label for Appointments tab
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.watch_later), // Waiting Room icon
              ),
              label: "Waiting Room", // Label for Waiting Room tab
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.person), // Profile icon
              ),
              label: "Profile", // Label for Profile tab
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the PageController when the widget is removed from the widget tree
    _pageController.dispose();
    super.dispose();
  }
}
