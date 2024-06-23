import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class UserPendingPage extends StatefulWidget {
  const UserPendingPage({super.key});

  @override
  State<UserPendingPage> createState() => _UserPendingPageState();
}

class _UserPendingPageState extends State<UserPendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                          ' You currently have a pending status. Please wait for the admin to accept your application',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.patrickHand(
                              color: Colors.black, fontSize: 25)),
                      const SizedBox(height: 10),
                      BlackButton(
                        text: "Log Out",
                        onTap: () async {
                          await context.read<UserAuthProvider>().signOut();
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
