import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/eventItem.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/eventModel.dart';
import 'package:sandiwapp/providers/event_provider.dart';

class OrgEvents extends StatefulWidget {
  const OrgEvents({super.key});

  @override
  State<OrgEvents> createState() => _OrgEventsState();
}

class _OrgEventsState extends State<OrgEvents> {
  final List<Event> events = [
    Event(
      date: DateTime.now(),
      title: "UPSSB SEM ENDER",
      place: "Pansol, Calamba City, Laguna",
      fee: "250",
      photoUrl:
          "https://static.wixstatic.com/media/a2331f_ec8660a43e8e43328b15a7b834c9b6e9~mv2.jpg/v1/crop/x_0,y_25,w_1000,h_512/fill/w_972,h_494,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/_MG_9145.jpg",
      attendees: [],
    ),
    Event(
      date: DateTime.now(),
      title: "Miting De Avance featuring alums brod and sisses night",
      place: "Makiling Ballroom Hall pero kahit saan naman pwede",
      fee: "0",
      photoUrl: null,
      attendees: [],
    ),
    Event(
      date: DateTime.parse('2021-02-27T14:00:00-08:00'),
      title: "General Assembly",
      place: "Zoom Meeting",
      fee: "0",
      photoUrl: null,
      attendees: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _eventsStream = context.watch<EventProvider>().events;
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 0, 16),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const PatrickHand(text: "Mga Pangyayari", fontSize: 33),
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
                        const Center(
                          child: Text("Upcoming Events",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Inter')),
                        ),
                        ...upcomingEvents.map((event) => GestureDetector(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.90,
                                  child: EventItem(event: event),
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: const Center(
                            child: Text(
                              "No Upcoming Events!",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      if (pastEvents.isNotEmpty) ...[
                        const Center(
                          child: Text("Past Events",
                              style: TextStyle(fontSize: 16)),
                        ),
                        ...pastEvents.map((event) => GestureDetector(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: FractionallySizedBox(
                                  widthFactor: 0.90,
                                  child: EventItem(event: event),
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: const Center(
                            child: Text(
                              "No Past Events!",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300),
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
