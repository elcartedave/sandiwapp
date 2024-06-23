import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        child: Column(
          children: [
            const Expanded(
                child: Center(
              child: Text(
                "ADMIN PAGE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 95,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      "About",
                      style: GoogleFonts.patrickHandSc(fontSize: 24),
                    ),
                    onTap: () {
                      // Handle About tap
                    },
                    trailing: Icon(Icons.navigate_next),
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.patrickHandSc(fontSize: 24),
                    ),
                    onTap: () async {
                      await context
                          .read<UserAuthProvider>()
                          .authService
                          .signOut();
                    },
                    trailing: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
