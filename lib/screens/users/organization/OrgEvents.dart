import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/eventItem.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/providers/event_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/execs/CreateEventPage.dart';
import 'package:sandiwapp/screens/users/organization/ViewEventPage.dart';

class OrgEvents extends StatefulWidget {
  const OrgEvents({super.key});

  @override
  State<OrgEvents> createState() => _OrgEventsState();
}

class _OrgEventsState extends State<OrgEvents> {
  bool isPinuno = false;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _eventsStream = context.watch<EventProvider>().events;
    Future<bool> isCurrentPinuno =
        context.read<UserProvider>().isCurrentPinuno();
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Expanded(
                    child: PatrickHand(text: "Mga Events/GA", fontSize: 33)),
                const SizedBox(width: 5),
                FutureBuilder(
                    future: isCurrentPinuno,
                    builder: (context, pinunoSnapshot) {
                      if (pinunoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(); // Or a loading indicator
                      }
                      if (pinunoSnapshot.data == true) {
                        isPinuno = true;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateEventPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              radius: Radius.circular(16),
                              strokeWidth: 2,
                              dashPattern: [8, 2],
                              borderPadding: EdgeInsets.all(2),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Magdagdag",
                                    style: blackText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    })
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
                stream: _eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Events Yet!"));
                  }
                  List<Event> events = snapshot.data!.docs.map((doc) {
                    return Event.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  DateTime now = DateTime.now();
                  List<Event> upcomingEvents =
                      events.where((event) => event.date.isAfter(now)).toList();
                  List<Event> pastEvents = events
                      .where((event) => event.date.isBefore(now))
                      .toList();

                  // Sort upcoming events by soonest first
                  upcomingEvents.sort((a, b) => a.date.compareTo(b.date));
                  // Sort past events by most recent first
                  pastEvents.sort((a, b) => b.date.compareTo(a.date));

                  return ListView(
                    children: [
                      if (upcomingEvents.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text("Upcoming Events",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'Inter')),
                          ),
                        ),
                        ...upcomingEvents.map((event) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewEventPage(
                                            isPast: false,
                                            event: event,
                                            isPinuno: isPinuno)));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.90,
                                  child: EventItem(isPast: false, event: event),
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              "No Upcoming Events!",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      if (pastEvents.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text("Past Events",
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        ...pastEvents.map((event) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewEventPage(
                                            isPast: true,
                                            event: event,
                                            isPinuno: isPinuno)));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.90,
                                  child: EventItem(isPast: true, event: event),
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              "No Past Events!",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
