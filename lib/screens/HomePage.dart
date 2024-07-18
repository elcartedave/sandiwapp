import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/LogoLoadingPage.dart';
import 'package:sandiwapp/screens/admin/AdminHomePage.dart';
import 'package:sandiwapp/screens/applicants/ApplicantHome.dart';
import 'package:sandiwapp/screens/auth_pages.dart/LogoPage.dart';
import 'package:sandiwapp/screens/users/UserHomePage.dart';
import 'package:sandiwapp/screens/users/UserPendingPage.dart';
import 'package:sandiwapp/models/userModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;
    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorPage(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LogoLoadingPage();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const LogoPage();
        }

        User? user = snapshot.data;
        return _buildHomePage(context, user!);
      },
    );
  }

  Widget _buildErrorPage(Object? error) {
    return Scaffold(
      body: Center(
        child: Text("Error encountered! $error"),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, User user) {
    Stream<DocumentSnapshot> userStream =
        context.watch<UserProvider>().fetchSpecificUser(user.uid);
    return StreamBuilder<DocumentSnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {}
        if (snapshot.hasError) {
          return const LogoLoadingPage();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const LogoLoadingPage();
        }

        MyUser userData =
            MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);

        if (userData.position == "Admin") {
          return const AdminHomePage();
        } else if (!userData.confirmed) {
          return const UserPendingPage();
        } else if (userData.position == "Aplikante") {
          return const ApplicantHome();
        } else {
          return const UserHomePage();
        }
      },
    );
  }
}
