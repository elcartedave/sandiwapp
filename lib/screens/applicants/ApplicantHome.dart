import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/applicantGridView.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/orgNavigator.dart';
import 'package:sandiwapp/components/orgOverviewMenu.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class ApplicantHome extends StatefulWidget {
  const ApplicantHome({super.key});

  @override
  State<ApplicantHome> createState() => _ApplicantHomeState();
}

class _ApplicantHomeState extends State<ApplicantHome> {
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();
    return StreamBuilder(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching user data"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            context.read<UserAuthProvider>().signOut();
            return const Center(child: Text("User data not available"));
          }

          MyUser user =
              MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    opacity: 0.5,
                    image: AssetImage("assets/images/whitebg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Kumusta, ${user.nickname}?",
                          style: GoogleFonts.lalezar(fontSize: 40),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            color: Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 0,
                                offset: Offset(4, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "UP Sandiwa Samahang Bulakenyo",
                                    style:
                                        GoogleFonts.leagueGothic(fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 14),
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 2, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                        ),
                                        child: Text(
                                          "Kilalanin",
                                          style: blackText,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.asset(
                                      'assets/images/sandiwa_cutout.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Dashboard",
                            style: GoogleFonts.lalezar(fontSize: 24)),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(8),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          crossAxisCount: 2,
                          children: [
                            ApplicantGrid(
                                icon: Icons.announcement,
                                text: "Announcements",
                                onTap: () {}),
                            ApplicantGrid(
                                icon: Icons.newspaper,
                                text: "Posts",
                                onTap: () {}),
                            ApplicantGrid(
                                icon: Icons.sms,
                                text: "Mga Mensahe",
                                onTap: () {}),
                            ApplicantGrid(
                                icon: Icons.calendar_month,
                                text: "Calendar of Events",
                                onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Mga Residente",
                                  style: GoogleFonts.lalezar(fontSize: 24)),
                              Text(
                                "See all",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
