import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/screens/admin/AdminHomePage.dart';
import 'package:sandiwapp/screens/auth_pages.dart/LogoPage.dart';
import 'package:sandiwapp/screens/users/UserHomePage.dart';
import 'package:sandiwapp/screens/users/UserPendingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;
    return StreamBuilder(
        stream: userStream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const LogoPage();
          }
          User? user = snapshot.data;
          return FutureBuilder<bool>(
              future: context
                  .read<UserAuthProvider>()
                  .authService
                  .isUserAdmin(user!.email!),
              builder: (context, adminSnapshot) {
                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    backgroundColor: Colors.white,
                    body: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  );
                } else if (adminSnapshot.data == true) {
                  return const AdminHomePage();
                } else {
                  return FutureBuilder<bool?>(
                      future: context
                          .read<UserAuthProvider>()
                          .authService
                          .userStatus(user.email!),
                      builder: (context, statusSnapshot) {
                        if (statusSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Scaffold(
                            backgroundColor: Colors.white,
                            body: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            ),
                          );
                        } else if (statusSnapshot.data == true) {
                          return const UserHomePage();
                        } else if (statusSnapshot.data == false) {
                          return const UserPendingPage();
                        } else {
                          return LogoPage();
                        }
                      });
                }
              });
        }));
  }
}
