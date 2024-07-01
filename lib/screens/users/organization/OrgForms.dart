import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/showFormsDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/formsModel.dart';
import 'package:sandiwapp/providers/forms_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/execs/CreateFormsPage.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgForms extends StatefulWidget {
  const OrgForms({super.key});

  @override
  State<OrgForms> createState() => _OrgFormsState();
}

class _OrgFormsState extends State<OrgForms> {
  bool isPinuno = false;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _formsStream = context.watch<FormsProvider>().forms;
    Future<bool> isCurrentPinuno =
        context.read<UserProvider>().isCurrentPinuno();
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 0, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: PatrickHand(text: "Mga Forms", fontSize: 33)),
              const SizedBox(width: 5),
              FutureBuilder(
                  future: isCurrentPinuno,
                  builder: (context, pinunoSnapshot) {
                    if (pinunoSnapshot.data == true) {
                      isPinuno = true;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateFormsPage()));
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
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
                stream: _formsStream,
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
                    return Center(child: Text("No Forms Yet!"));
                  }
                  List<MyForm> forms = snapshot.data!.docs.map((doc) {
                    return MyForm.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  DateTime now = DateTime.now();
                  List<MyForm> upcomingForms =
                      forms.where((form) => form.date.isAfter(now)).toList();
                  List<MyForm> pastForms =
                      forms.where((form) => form.date.isBefore(now)).toList();

                  // Sort upcoming events by soonest first
                  upcomingForms.sort((a, b) => a.date.compareTo(b.date));
                  // Sort past events by most recent first
                  pastForms.sort((a, b) => b.date.compareTo(a.date));

                  return ListView(
                    children: [
                      if (upcomingForms.isNotEmpty) ...[
                        Center(
                          child: Text("Active Forms",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Inter')),
                        ),
                        ...upcomingForms.map((form) => InkWell(
                              splashColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              onTap: () {
                                launchUrl(Uri.parse(form.url),
                                    mode: LaunchMode.platformDefault);
                              },
                              onLongPress: () {
                                if (isPinuno)
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ShowFormsDialog(form: form));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                        decoration:
                                            BoxDecoration(color: Colors.black),
                                        child: Icon(
                                          Icons.edit,
                                          size: 65,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            form.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.patrickHand(
                                              height: 1,
                                              fontSize: 23,
                                            ),
                                          ),
                                          PatrickHand(
                                              text:
                                                  "Due date: ${dateFormatter(form.date)}",
                                              fontSize: 14),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: const Center(
                            child: Text(
                              "No Active Forms!",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      if (pastForms.isNotEmpty) ...[
                        Center(
                          child: Text("Previous Forms",
                              style: TextStyle(fontSize: 16)),
                        ),
                        ...pastForms.map((form) => InkWell(
                              splashColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              onTap: () {
                                launchUrl(Uri.parse(form.url),
                                    mode: LaunchMode.platformDefault);
                              },
                              onLongPress: () {
                                if (isPinuno)
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ShowFormsDialog(form: form));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                        decoration:
                                            BoxDecoration(color: Colors.black),
                                        child: Icon(
                                          Icons.edit,
                                          size: 65,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            form.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.patrickHand(
                                              height: 1,
                                              fontSize: 23,
                                            ),
                                          ),
                                          PatrickHand(
                                              text:
                                                  "Due date: ${dateFormatter(form.date)}",
                                              fontSize: 14),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ] else
                        const SizedBox(
                          height: 150,
                          child: const Center(
                            child: Text(
                              "No Previous Forms!",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
          )
        ],
      ),
    );
    ;
  }
}
