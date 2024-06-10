import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/auth_pages.dart/Login.dart';
import 'package:sandiwapp/auth_pages.dart/SignUp.dart';
import 'package:sandiwapp/components/button.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  Text(
                    "SANDIWA LOGO",
                    style: GoogleFonts.patrickHand(
                      color: Colors.black,
                      fontSize: 64,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 180),
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
