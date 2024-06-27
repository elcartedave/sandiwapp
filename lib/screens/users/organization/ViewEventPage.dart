import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showEventsDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class ViewEventPage extends StatefulWidget {
  const ViewEventPage(
      {required this.isPast,
      required this.event,
      required this.isPinuno,
      super.key});
  final Event event;
  final bool isPinuno;
  final bool isPast;
  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  bool isClicked = true;
  late List<Widget> selectedButton;
  late List<Widget> notSelectedButton;
  late List<MyUser> attendees;
  late List<MyUser> nonAttendees;
  PageController _pageController = PageController(initialPage: 0);

  Widget menuButton() {
    return SizedBox(
        width: 255,
        child: Stack(children: isClicked ? selectedButton : notSelectedButton));
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStream = context.watch<UserProvider>().users;
    selectedButton = [
      Container(
        alignment: Alignment.topRight,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 3.0, horizontal: 25.0)),
            minimumSize: WidgetStateProperty.all<Size>(Size(2, 1)),
          ),
          onPressed: () {
            setState(() {
              isClicked = !isClicked;
              _pageController.animateToPage(isClicked ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          },
          child: Text(
            widget.isPast ? "Mga Hindi Pumunta" : "Mga Hindi Pupunta",
            style: GoogleFonts.patrickHand(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(const Color.fromARGB(255, 43, 43, 43)),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 3.0, horizontal: 25.0)),
            minimumSize: WidgetStateProperty.all<Size>(Size(4, 1)),
          ),
          onPressed: () {},
          child: Text(
            widget.isPast ? "Mga Pumunta" : "Mga Pupunta",
            style: GoogleFonts.patrickHand(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ];

    notSelectedButton = [
      Container(
        alignment: Alignment.topLeft,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 3.0, horizontal: 25.0)),
            minimumSize: WidgetStateProperty.all<Size>(Size(4, 1)),
          ),
          onPressed: () {
            setState(() {
              isClicked = !isClicked;
              _pageController.animateToPage(isClicked ? 0 : 1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            });
          },
          child: Text(
            widget.isPast ? "Mga Pumunta" : "Mga Pupunta",
            style: GoogleFonts.patrickHand(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      Container(
        alignment: Alignment.topRight,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Color.fromARGB(255, 43, 43, 43)),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 3.0, horizontal: 25.0)),
            minimumSize: WidgetStateProperty.all<Size>(Size(2, 1)),
          ),
          onPressed: () {},
          child: Text(
            widget.isPast ? "Mga Hindi Pumunta" : "Mga Hindi Pupunta",
            style: GoogleFonts.patrickHand(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 43, 43, 43),
        title: widget.isPinuno == false
            ? Text(
                "Detalye ng Event/GA",
                style:
                    GoogleFonts.patrickHand(fontSize: 20, color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Detalye ng Event/GA",
                    style: GoogleFonts.patrickHand(
                        fontSize: 20, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              ShowEventDialog(event: widget.event));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.5,
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      child: Container(
                        color: Color.fromARGB(255, 43, 43, 43),
                        child: widget.event.photoUrl == ""
                            ? Image.asset(
                                'assets/images/base_image.png',
                                height: 350,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Opacity(
                                opacity: 0.8,
                                child: Image.network(
                                  widget.event.photoUrl!,
                                  fit: BoxFit.contain,
                                  height: 350,
                                  width: double.infinity,
                                ),
                              ),
                      )),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.event.title.toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                          widget.event.place,
                          style: GoogleFonts.patrickHand(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          dateFormatter(widget.event.date),
                          style: GoogleFonts.patrickHand(
                              fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      widget.event.fee == "0.0" || widget.event.fee == "0"
                          ? Container()
                          : Column(
                              children: [
                                const SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Php ${widget.event.fee} fee",
                                    style: GoogleFonts.patrickHand(
                                        fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      menuButton(),
                      const SizedBox(height: 20),
                      StreamBuilder(
                          stream: _userStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 300,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                )),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text(
                                "No Attendees!",
                                style: TextStyle(color: Colors.white),
                              ));
                            }
                            List<MyUser> users = snapshot.data!.docs.map((doc) {
                              return MyUser.fromJson(
                                  doc.data() as Map<String, dynamic>);
                            }).toList();

                            attendees = users
                                .where((user) =>
                                    widget.event.attendees!.contains(user.id))
                                .toList();

                            nonAttendees = users
                                .where((user) =>
                                    !widget.event.attendees!.contains(user.id))
                                .toList();
                            return Container(
                              height: 300,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: PageView(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    isClicked = index == 0;
                                  });
                                },
                                children: [
                                  buildGridView(attendees),
                                  buildGridView(nonAttendees),
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                ],
              ),
            ),
          ),
          widget.isPast
              ? Container()
              : Positioned(
                  bottom: 16,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Flexible(
                          child: GestureDetector(
                        onTap: () async {
                          await context
                              .read<EventProvider>()
                              .toggleGoing(widget.event.id!, true);
                          Navigator.pop(context);
                          showCustomSnackBar(
                              context, "You are going to the event", 85);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 43, 43, 43),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            "Going",
                            style: whiteText,
                          )),
                        ),
                      )),
                      const SizedBox(width: 10),
                      Flexible(
                          child: BlackButton(
                        text: "Not Going",
                        onTap: () async {
                          await context
                              .read<EventProvider>()
                              .toggleGoing(widget.event.id!, false);
                          Navigator.pop(context);
                          showCustomSnackBar(
                              context, "You are not going to the event", 85);
                        },
                      ))
                    ],
                  ),
                )
        ]),
      ),
    );
  }

  Widget buildGridView(List<MyUser> users) {
    return users.length == 0
        ? Container(
            height: 300,
            child: Center(
                child: Text(
              "No Resis!",
              style: TextStyle(color: Colors.white),
            )))
        : GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return buildUserCard(users[index]);
            },
          );
  }

  Widget buildUserCard(MyUser user) {
    return Container(
      child: Column(
        children: [
          user.photoUrl == null || user.photoUrl == ""
              ? Image.asset(
                  'assets/images/base_image.png',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.fill,
                )
              : Image.network(
                  user.photoUrl!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Image is fully loaded
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                if (loadingProgress.expectedTotalBytes != null)
                                  Text(
                                    '${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
          Text(user.name,
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
