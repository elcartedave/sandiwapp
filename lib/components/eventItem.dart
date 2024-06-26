import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Add this line
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart'; // Add this line

class EventItem extends StatefulWidget {
  final Event event;
  final bool isPast;
  const EventItem({required this.isPast, required this.event, super.key});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  String clicked = "Not";

  void _toggleGoing(String userId, bool going) async {
    // if (widget.isPast) {
    //   showCustomSnackBar(context, "You cannot edit a past event", 85);
    //   return;
    // }
    await context.read<EventProvider>().toggleGoing(widget.event.id!, going);
    clicked = going ? "Going" : "Not";
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: widget.event.photoUrl == null || widget.event.photoUrl == ""
                ? Image.asset(
                    'assets/images/base_image.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  )
                : ImageBuffer(
                    photoURL: widget.event.photoUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.event.title,
            style: GoogleFonts.patrickHand(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          SelectableText(
            widget.event.place,
            style: GoogleFonts.patrickHand(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          PatrickHand(
            text: dateFormatter(widget.event.date),
            fontSize: 20,
          ),
          const SizedBox(height: 5),
          widget.event.fee == "0"
              ? Container()
              : PatrickHand(
                  text: "Php ${widget.event.fee} fee",
                  fontSize: 20,
                ),
          const SizedBox(height: 8),
          StreamBuilder(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error fetching user data"));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text("User data not available"));
                }

                MyUser user = MyUser.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                print("my userid: ${user.id!}");
                bool isGoing =
                    widget.event.attendees?.contains(user.id!) ?? false;
                clicked = isGoing ? "Going" : "Not";

                return widget.isPast
                    ? WhiteButton(
                        text:
                            "Bilang ng Mga Umattend: ${widget.event.attendees!.length}")
                    : Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _toggleGoing(user.id!, true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: clicked == "Going"
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  clicked == "Going" ? "I'm Going" : "Going",
                                  style: clicked == "Going"
                                      ? whiteText
                                      : blackText,
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _toggleGoing(user.id!, false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    color: clicked != "Not"
                                        ? Colors.white
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  clicked != "Not"
                                      ? "Not Going"
                                      : "I'm Not Going",
                                  style:
                                      clicked != "Not" ? blackText : whiteText,
                                )),
                              ),
                            ),
                          )
                        ],
                      );
              })
        ],
      ),
    );
  }
}
