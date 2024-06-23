import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/navbar.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    navbar = Navbar(
        navBarText,
        (int val) => setState(() {
              _currentIndex = val;
            }),
        _currentIndex);
    return Scaffold(
      backgroundColor: _currentIndex == 2 ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: _currentIndex == 2 ? Colors.black : Colors.white,
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
    );
  }
}
