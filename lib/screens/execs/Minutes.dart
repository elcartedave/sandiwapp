import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/createMinutes.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showMinutesDialog.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:sandiwapp/screens/execs/CreateMinutesQuill.dart';
import 'package:sandiwapp/screens/users/dashboard/ViewMinutes.dart';
import 'package:url_launcher/url_launcher.dart';

class Minutes extends StatefulWidget {
  final bool? isPinuno;
  const Minutes({this.isPinuno, super.key});

  @override
  State<Minutes> createState() => _MinutesState();
}

class _MinutesState extends State<Minutes> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _minutesStream =
        context.watch<LinkProvider>().minutes;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text("Minutes of the Meeting",
            style: GoogleFonts.patrickHand(fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: StreamBuilder(
                  stream: _minutesStream,
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
                      return Center(child: Text("No Minutes Yet!"));
                    }
                    var minutes = snapshot.data!.docs.map((doc) {
                      return Link.fromJson(doc.data() as Map<String, dynamic>);
                    }).toList();
                    minutes.sort((a, b) => b.date.compareTo(a.date));
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        itemCount: minutes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (minutes[index].caption != null &&
                                    minutes[index].caption != "") {
                                  if (widget.isPinuno != null &&
                                      widget.isPinuno == true) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateMinutesQuill(
                                                  isNewMinutes: false,
                                                  minutes: minutes[index],
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewMinutes(
                                                  minutes: minutes[index],
                                                )));
                                  }
                                } else
                                  launchUrl(Uri.parse(minutes[index].url),
                                      mode: LaunchMode.platformDefault);
                              },
                              onLongPress: () {
                                if (minutes[index].caption != null &&
                                    minutes[index].caption != "" &&
                                    widget.isPinuno != null &&
                                    widget.isPinuno == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ShowMinutesDialog(
                                          deleteOnly: true,
                                          minutes: minutes[index]));
                                } else if (widget.isPinuno != null &&
                                    widget.isPinuno == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ShowMinutesDialog(
                                          minutes: minutes[index]));
                                }
                              },
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: Center(
                                    child: PatrickHand(
                                        text: minutes[index].title,
                                        fontSize: 16),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(dateFormatter(minutes[index].date)),
                                      minutes[index].caption != null &&
                                              minutes[index].caption != ""
                                          ? Text(minutes[index].caption!,
                                              maxLines: 2)
                                          : Text(minutes[index].url),
                                    ],
                                  ),
                                  trailing: Icon(Icons.edit_document, size: 30),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ),
          widget.isPinuno != null && widget.isPinuno == true
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      BlackButton(
                        text: "Mag-add ng Link",
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => CreateMinutes());
                        },
                      ),
                      const SizedBox(height: 10),
                      WhiteButton(
                        text: "Gumawa ng Minutes",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateMinutesQuill(
                                        isNewMinutes: true,
                                      )));
                        },
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
