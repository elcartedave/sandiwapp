import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
              color: Colors.white,
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching user data"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            context.read<UserAuthProvider>().signOut();
            return Center(child: Text("User data not available"));
          }
          MyUser user =
              MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                opacity: 0.6,
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(top: 5, bottom: 25, left: 25, right: 25),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5100)),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(50), // Image radius
                                child:
                                    user.photoUrl == "" || user.photoUrl == null
                                        ? Icon(
                                            Icons.account_circle,
                                            color: Colors.white,
                                            size: 100,
                                          )
                                        : Image.network(
                                            user.photoUrl!,
                                            width: 100,
                                            fit: BoxFit.contain,
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 7,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.inter(
                                    color: Colors.white, fontSize: 28),
                              ),
                              Text(
                                user.position!,
                                style: GoogleFonts.judson(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                user.lupon!,
                                style: GoogleFonts.judson(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInfoRow("Nickname:", user.nickname),
                            buildInfoRow("Email:", user.email),
                            buildInfoRow("Birthday:", user.birthday),
                            buildInfoRow("Age:", user.age),
                            buildInfoRow("Contact Number:", user.contactno),
                            buildInfoRow(
                                "College Address:", user.collegeAddress),
                            buildInfoRow("Home Address:", user.homeAddress),
                            buildInfoRow("Sponsor:", user.sponsor),
                            buildInfoRow("Batch:", user.batch),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
            ),
          );
        });
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: GoogleFonts.patrickHand(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
