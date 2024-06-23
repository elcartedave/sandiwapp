import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/screens/auth_pages.dart/Login.dart';
import 'package:sandiwapp/screens/auth_pages.dart/SignUp.dart';
import 'package:sandiwapp/components/button.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Image.asset('assets/icons/sandiwa_logo.png', width: 350),
                      Text(
                        "SANDIWA",
                        style: GoogleFonts.patrickHandSc(
                            color: Colors.black, fontSize: 60),
                      ),
                      Text(
                        "Tungo sa makabuluhang pagkilos at paglilingkod",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 18, height: 1.0),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  const SizedBox(height: 100),
                  BlackButton(
                    text: "Mag log-in",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return LogIn();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  MyTextButton(
                    text: "Gumawa ng Account",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignUp()), //pupunta sa sign in page
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
