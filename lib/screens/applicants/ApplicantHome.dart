import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/applicantGridView.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/MessagesList.dart';
import 'package:sandiwapp/screens/applicants/AllResidentsPage.dart';
import 'package:sandiwapp/screens/applicants/ApplicantAnnouncement.dart';
import 'package:sandiwapp/screens/applicants/ApplicantCalendar.dart';
import 'package:sandiwapp/screens/applicants/ApplicantOrgPage.dart';
import 'package:sandiwapp/screens/applicants/ApplicantPosts.dart';
import 'package:sandiwapp/screens/applicants/ApplicantProfilePge.dart';
import 'package:sandiwapp/screens/applicants/ApplicantResidents.dart';

class ApplicantHome extends StatefulWidget {
  const ApplicantHome({super.key});

  @override
  State<ApplicantHome> createState() => _ApplicantHomeState();
}

class _ApplicantHomeState extends State<ApplicantHome> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage("assets/images/whitebg.jpg"), context);
    precacheImage(
        const AssetImage('assets/images/sandiwa_cutout.png'), context);
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

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
            backgroundColor: Colors.white,
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  opacity: 0.3,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Kumusta, ${user.nickname}?",
                              style: GoogleFonts.lalezar(fontSize: 40),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ApplicantProfilePage()));
                              },
                              child: Icon(Icons.account_circle, size: 40))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 220,
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
                                  style: GoogleFonts.leagueGothic(fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    'assets/images/sandiwa_cutout.png',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ApplicantOrgPage()));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 14),
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
                              onTap: () => _navigateToPage(
                                  ApplicantAnnouncement(isPinuno: false))),
                          ApplicantGrid(
                              icon: Icons.newspaper,
                              text: "Posts",
                              onTap: () =>
                                  _navigateToPage(ApplicantPostsPage())),
                          ApplicantGrid(
                              icon: Icons.sms,
                              text: "Mga Mensahe",
                              onTap: () => _navigateToPage(
                                  ChatRoomsPage(myPhotoUrl: user.photoUrl!))),
                          ApplicantGrid(
                              icon: Icons.calendar_month,
                              text: "Calendar of Events",
                              onTap: () => _navigateToPage(ApplicantCalendar(
                                  userID: user.id!,
                                  selectedDay: DateTime.now()))),
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllResidentsPage()));
                              },
                              child: Text(
                                "See all",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                      ApplicantResidents()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
