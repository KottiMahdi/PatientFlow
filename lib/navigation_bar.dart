import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/pages/agenda/agenda_page.dart';
import 'package:management_cabinet_medical_mobile/pages/attente/Salle_dattente_page.dart';
import 'package:management_cabinet_medical_mobile/pages/home_page.dart';
import 'package:management_cabinet_medical_mobile/pages/patients/patients_page.dart';

class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<navigationBar> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Dynamically adjust font size based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth > 360 ? 12 : 10;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _pageController,
          physics: const ScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            const HomePage(),
            PatientsPage(),
            AgendaPage(),
            const SalleDattentePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: fontSize - 1,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.home),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.group),
              ),
              label: "Patients",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.event),
              ),
              label: "Appointments",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.watch_later),
              ),
              label: "Waiting Room",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Icon(Icons.person),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
