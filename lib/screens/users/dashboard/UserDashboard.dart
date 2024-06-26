import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/amountBox.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/dottedBorder.dart';
import 'package:sandiwapp/components/messages.dart';
import 'package:sandiwapp/components/sendMessage.dart';
import 'package:sandiwapp/components/taskManager.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/execs/ViewPaymentsPage.dart';
import 'package:sandiwapp/screens/users/dashboard/CommiteeAnnouncement.dart';
import 'package:sandiwapp/screens/users/dashboard/PaymentPage.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                opacity: 0.5,
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kumusta, ${user.nickname}?',
                      style: GoogleFonts.patrickHand(fontSize: 32),
                    ),
                    const SizedBox(height: 20),
                    AmountBox(amount: user.balance, onTap: () {}),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WhiteButton(
                          text: "Bayaran",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage(user)),
                            );
                          },
                        ),
                        WhiteButton(
                          acknowledged: user.acknowledged,
                          text: "Acknowledge",
                          onTap: () async {
                            await context
                                .read<UserProvider>()
                                .toggleAcknowledged(
                                    user.email, !user.acknowledged);
                          },
                        ),
                        WhiteButton(
                          text: "Magmensahe",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SendMessage();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('MERIT POINTS',
                                    style: GoogleFonts.inter(fontSize: 18)),
                                Text(user.merit,
                                    style: TextStyle(fontSize: 24)),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                              color: Colors.black, thickness: 2),
                          Expanded(
                            child: Column(
                              children: [
                                Text('DEMERIT POINTS',
                                    style: GoogleFonts.inter(fontSize: 18)),
                                Text(user.demerit,
                                    style: TextStyle(fontSize: 24)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Pananalapi"))
                      Column(
                        children: [
                          WhiteButton(
                            text: "Mag-assign ng Balanse",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          WhiteButton(
                            text: "Mag-assign ng Merits/Demerits",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                          WhiteButton(
                            text: "View Payments",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewPaymentsPage()), //pupunta sa sign in page
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Kasapian"))
                      Column(
                        children: [
                          WhiteButton(
                            text: "Applicant Announcements",
                            onTap: () {},
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    if (user.position!.contains("Kalihim"))
                      Column(
                        children: [
                          WhiteButton(
                            text: "Attendance Tracker",
                            onTap: () {},
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    Text(
                      'Ang Aking Lupon:',
                      style: GoogleFonts.patrickHand(fontSize: 20),
                    ),
                    SizedBox(height: 4),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (user.position!.contains("Pinuno"))
                              Row(
                                children: [
                                  MyDottedBorder(
                                    text: "Mga Kasapi ng Lupon",
                                    icon: Icon(Icons.people),
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 15)
                                ],
                              ),
                            MyDottedBorder(
                              text: "Committee Announcements",
                              icon: Icon(Icons.announcement),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommitteeAnnouncement(
                                            isLuponHead: user.position!
                                                .contains("Pinuno"),
                                          )), //pupunta sa sign in page
                                );
                              },
                            ),
                            const SizedBox(width: 15),
                            MyDottedBorder(
                              text: "   Task Assignments    ",
                              icon: Icon(Icons.assignment),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return TaskManager();
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 15),
                            MyDottedBorder(
                              text: "   Committee Tracker   ",
                              icon: Icon(Icons.track_changes),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Mensahe/Follow-up:',
                      style: GoogleFonts.patrickHand(fontSize: 20),
                    ),
                    MyMessages()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
