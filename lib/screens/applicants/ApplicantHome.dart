import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';

class ApplicantHome extends StatefulWidget {
  const ApplicantHome({super.key});

  @override
  State<ApplicantHome> createState() => _ApplicantHomeState();
}

class _ApplicantHomeState extends State<ApplicantHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Applicant Page"),
              BlackButton(
                text: "Log Out",
                onTap: () async {
                  await context.read<UserAuthProvider>().signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
