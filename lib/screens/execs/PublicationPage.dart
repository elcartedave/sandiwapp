import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/createPubLink.dart';
import 'package:sandiwapp/components/showPubLinkDialog.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicationPage extends StatefulWidget {
  final bool isPinuno;
  const PublicationPage({required this.isPinuno, super.key});

  @override
  State<PublicationPage> createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _publinksStream =
        context.watch<LinkProvider>().publinks;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text("Mga Publication Links",
            style: GoogleFonts.patrickHand(fontSize: 24)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: StreamBuilder(
                  stream: _publinksStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No Links Yet!"));
                    }
                    var publinks = snapshot.data!.docs.map((doc) {
                      return Link.fromJson(doc.data() as Map<String, dynamic>);
                    }).toList();
                    publinks.sort((a, b) => b.date.compareTo(a.date));
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        itemCount: publinks.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                launchUrl(Uri.parse(publinks[index].url),
                                    mode: LaunchMode.platformDefault);
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => ShowPubLinkDialog(
                                        pubLink: publinks[index]));
                              },
                              child: Card(
                                elevation: 5,
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: PatrickHand(
                                      text: publinks[index].title,
                                      fontSize: 16),
                                  subtitle: Text(publinks[index].url),
                                  trailing: Icon(Icons.format_paint, size: 30),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ),
          !widget.isPinuno
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlackButton(
                    text: "Mag-add ng Link",
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => CreatePubLink());
                    },
                  ),
                )
        ],
      ),
    );
  }
}
