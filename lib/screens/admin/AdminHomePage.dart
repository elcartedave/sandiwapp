import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/navbar.dart';
import 'package:sandiwapp/screens/admin/AdminOrgResidents.dart';
import 'package:sandiwapp/screens/admin/AdminProfilePage.dart';
import 'package:sandiwapp/screens/admin/ConfirmMemberPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;
  late Navbar navbar;
  List<String> appBarText = ["Confirm Members", "Delete Members", "Profile"];
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
        /////////////////////////////Confirm Page/////////////////////////
        ConfirmMemberPage(),
        /////////////////////////////Delete Page/////////////////////////
        Container(padding: EdgeInsets.all(8), child: AdminOrgResidents()),
        /////////////////////////////PROFILE PAGE/////////////////////////
        AdminProfilePage(),
      ][_currentIndex],
    );
  }
}
