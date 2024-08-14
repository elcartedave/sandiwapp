import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/amountBox.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/committeeTracker.dart';
import 'package:sandiwapp/components/dottedBorder.dart';
import 'package:sandiwapp/components/taskManager.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/MessagesList.dart';
import 'package:sandiwapp/screens/applicants/ApplicantAnnouncement.dart';
import 'package:sandiwapp/screens/execs/LuponMembers.dart';
import 'package:sandiwapp/screens/execs/MeritDemeritPage.dart';
import 'package:sandiwapp/screens/execs/Minutes.dart';
import 'package:sandiwapp/screens/execs/PublicationPage.dart';
import 'package:sandiwapp/screens/execs/ViewAssignBalance.dart';
import 'package:sandiwapp/screens/execs/ViewPaymentsPage.dart';
import 'package:sandiwapp/screens/execs/ViewStatement.dart';
import 'package:sandiwapp/screens/users/dashboard/BulacanStatementPage.dart';
import 'package:sandiwapp/screens/users/dashboard/CommiteeAnnouncement.dart';
import 'package:sandiwapp/screens/users/dashboard/EventsCalendar.dart';
import 'package:sandiwapp/screens/users/dashboard/PaymentPage.dart';
import 'package:sandiwapp/screens/users/dashboard/PersonalNotes.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Stream<DocumentSnapshot> _trackerStream =
              context.watch<LinkProvider>().fetchCommittee(user.lupon!);
          List<Map<String, dynamic>> buttons = [
            {
              'icon': Icons.calendar_today,
              'text': "Sandiwa Calendar",
              'onTap': () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventsCalendar(
                              isPinuno: user.position!.contains("Pinuno"),
                              lupon: user.lupon!,
                            )));
              },
            },
            {
              'icon': Icons.track_changes,
              'text': "Bloodline Tracker",
              'onTap': () {},
            },
            {
              'icon': Icons.task,
              'text': "Task Assignments",
              'onTap': () {
                showDialog(
                    context: context,
                    builder: (context) => TaskManagerDialog());
              },
            },
            {
              'icon': Icons.edit_note,
              'text': "My Personal Notes",
              'onTap': () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalNotes(
                              userId: user.id!,
                            )));
              }, // Add your desired onTap action here
            },
          ];
          return Container(
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
                          text: "Mga Mensahe",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatRoomsPage(
                                          myPhotoUrl: user.photoUrl!,
                                        )));
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
                    SizedBox(height: 10),
                    ///////////////For users in general///////////////
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        crossAxisSpacing: 10.0, // Spacing between columns
                        childAspectRatio:
                            3 / 2, // Aspect ratio of each grid item
                      ),
                      itemCount: buttons.length,
                      itemBuilder: (context, index) {
                        return WhiteBoxWithIcon(
                          iconData: buttons[index]['icon'],
                          text: buttons[index]['text'],
                          onTap: buttons[index]['onTap'],
                        );
                      },
                    ),
                    ///////////////////////////Unique Pinuno features///////////////////////////
                    if (!user.position!.contains("Residente") &&
                        !user.position!.contains("Aplikante"))
                      Column(
                        children: [
                          Text(
                            'Gawain Bilang Exec:',
                            style: GoogleFonts.patrickHand(fontSize: 20),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Edukasyon"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.approval,
                            text: "View Monthly Statements",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewStatementPage()));
                            },
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Pananalapi"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.monetization_on,
                            text: "Mag-assign ng Balanse",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewAssignBalancePage()));
                            },
                          ),
                          const SizedBox(height: 10),
                          WhiteButtonWithIcon(
                            iconData: Icons.assignment,
                            text: "Mag-assign ng Merits/Demerits",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MeritDemeritPage()));
                            },
                          ),
                          const SizedBox(height: 10),
                          WhiteButtonWithIcon(
                            iconData: Icons.money,
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Kasapian"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.people_alt,
                            text: "Applicant Announcements",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplicantAnnouncement(
                                              isPinuno: true)));
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (user.position!.contains("Pinuno") &&
                        user.lupon!.contains("Ugnayang Panlabas"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.handshake,
                            text: "Partnerships",
                            onTap: () {},
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    if (user.position!.contains("Kalihim"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.format_list_bulleted,
                            text: "Minutes",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Minutes(isPinuno: true)));
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                    if (!user.position!.contains("Residente") &&
                        !user.position!.contains("Aplikante"))
                      Column(
                        children: [
                          WhiteButtonWithIcon(
                            iconData: Icons.folder_shared,
                            text: "UPSSB Executives' Repository",
                            onTap: () {
                              launchUrl(
                                  Uri.parse(
                                      "https://drive.google.com/drive/u/0/folders/0ALuv2HUG_2L2Uk9PVA"),
                                  mode: LaunchMode.platformDefault);
                            },
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),

                    ////////////LUPON////////////////
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
                            ///////////////Exclusive to Head Only///////////////////////////////
                            if (user.position!.contains("Pinuno"))
                              Row(
                                children: [
                                  MyDottedBorder(
                                    text: "Mga Kasapi ng Lupon",
                                    icon: Icon(Icons.people),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LuponMembers(
                                                    lupon: user.lupon!,
                                                  )));
                                    },
                                  ),
                                  const SizedBox(width: 15)
                                ],
                              ),
                            //////////////////unique lupon members' features//////////////////////////////////
                            if (user.lupon!.contains("Edukasyon"))
                              Row(
                                children: [
                                  MyDottedBorder(
                                    text: "Bulacan/Monthly Statements",
                                    icon: Icon(Icons.message),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BulacanStatementPage()));
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              ),
                            if (user.lupon!.contains("Publikasyon"))
                              Row(
                                children: [
                                  MyDottedBorder(
                                    text: "Important Links",
                                    icon: Icon(Icons.link),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PublicationPage(
                                                    isPinuno: user.position!
                                                        .contains("Pinuno"),
                                                  )));
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              ),

                            ///////////Exclusive to Lupon Only//////////////
                            MyDottedBorder(
                              text: "Committee Announcements",
                              icon: Icon(Icons.announcement),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CommitteeAnnouncement(
                                            user: user,
                                          )), //pupunta sa sign in page
                                );
                              },
                            ),
                            const SizedBox(width: 15),
                            StreamBuilder(
                                stream: _trackerStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return MyDottedBorder(
                                      text: "   Committee Tracker   ",
                                      icon: Icon(Icons.track_changes),
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CommitteeTracker(
                                                    lupon: user.lupon!,
                                                    isPinuno: user.position!
                                                        .contains("Pinuno")));
                                      },
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      !snapshot.data!.exists) {
                                    return Center(
                                        child: Text("No Tracker Yet!"));
                                  }
                                  var tracker = Link.fromJson(snapshot.data!
                                      .data() as Map<String, dynamic>);

                                  return MyDottedBorder(
                                    text: "   Committee Tracker   ",
                                    icon: Icon(Icons.track_changes),
                                    onTap: () {
                                      launchUrl(Uri.parse(tracker.url));
                                    },
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
