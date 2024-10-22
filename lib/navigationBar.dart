import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:management_cabinet_medical_mobile/pages/listPatients.dart';
import 'package:management_cabinet_medical_mobile/pages/test.dart';


class navigationBar extends StatefulWidget {
  const navigationBar({super.key});

  @override
  State<navigationBar> createState() => _navigationBarState();
}

class _navigationBarState extends State<navigationBar> {
  late PageController _pageController;
  int page = 0;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  onPageChanged(int pageParam) {
    setState(() {
      page = pageParam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const ScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const <Widget>[
          ListPatients(),
          test()

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: navigationTapped,
          backgroundColor: Colors.grey.shade50,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: page,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Padding(
                  padding:   EdgeInsets.only(top: 15.0),
                  /*child: Image.asset(
                    'assets/img/Icon_Explore.png',
                    fit: BoxFit.contain,
                    width: 20,
                  ),*/
                ),
                label: '',
                activeIcon:   Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Text('Patients'),
                )),
            BottomNavigationBarItem(
                icon: Padding(
                  padding:   EdgeInsets.only(top: 15.0),
                  /*child: Image.asset('assets/img/Icon_Cart.png',
                      fit: BoxFit.contain, width: 20),*/
                ),
                label: 'test',
                activeIcon:   Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text('Cart'),
                )),
            BottomNavigationBarItem(
                icon: Padding(
                  padding:   EdgeInsets.only(top: 15.0),
                  /*child: Image.asset('assets/img/Icon_User.png',
                      fit: BoxFit.contain, width: 20),*/
                ),
                label: 'test',
                activeIcon:   Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text('Account'),
                )),
          ]),
    );
  }
}
