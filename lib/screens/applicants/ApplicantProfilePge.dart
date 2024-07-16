import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/screens/users/UserProfilePage.dart';

class ApplicantProfilePage extends StatefulWidget {
  const ApplicantProfilePage({super.key});

  @override
  State<ApplicantProfilePage> createState() => _ApplicantProfilePageState();
}

class _ApplicantProfilePageState extends State<ApplicantProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Container(color: Colors.black),
      ),
      Positioned.fill(
        child: Image.asset(
          "assets/images/bg2.png",
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(0.6),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: Text("My Profile",
              style:
                  GoogleFonts.patrickHandSc(fontSize: 24, color: Colors.white)),
        ),
        body: UserProfilePage(isApplicant: true),
      ),
    ]);
  }
}
