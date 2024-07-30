import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/navbar.dart';
import 'package:sandiwapp/screens/users/UserProfilePage.dart';
import 'package:sandiwapp/screens/users/dashboard/UserDashboard.dart';
import 'package:sandiwapp/screens/users/organization/OrgDashboard.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;
  late Navbar navbar;
  List<String> appBarText = ["My Dashboard", "UPSSB", "Profile"];
  List<String> navBarText = ["Dashboard", "Organization", "Profile"];
  List<String> photoURL = [
    "assets/images/bg.png",
    "assets/images/bg1.png",
    "assets/images/bg2.png"
  ];
  @override
  Widget build(BuildContext context) {
    navbar = Navbar(
        navBarText,
        (int val) => setState(() {
              _currentIndex = val;
            }),
        _currentIndex);

    return Stack(children: [
      Positioned.fill(
        child:
            Container(color: _currentIndex == 2 ? Colors.black : Colors.white),
      ),
      Positioned.fill(
        child: Image.asset(
          photoURL[_currentIndex],
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(0.5),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            appBarText[_currentIndex],
            style: GoogleFonts.patrickHand(
                color: _currentIndex == 2 ? Colors.white : Colors.black,
                fontWeight: FontWeight.w700),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 20.0,
          scrolledUnderElevation: 0.0,
        ),
        bottomNavigationBar: navbar,
        body: [
          /////////////////////////////DASHBOARD PAGE/////////////////////////
          UserDashboard(),
          /////////////////////////////HOME PAGE/////////////////////////
          OrgDashboard(),
          /////////////////////////////PROFILE PAGE/////////////////////////
          UserProfilePage(),
        ][_currentIndex],
      ),
    ]);
  }
}
