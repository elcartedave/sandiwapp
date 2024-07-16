import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/deletePostDialog.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicantPostsPage extends StatefulWidget {
  const ApplicantPostsPage({super.key});

  @override
  State<ApplicantPostsPage> createState() => _ApplicantPostsPageState();
}

class _ApplicantPostsPageState extends State<ApplicantPostsPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _postsStream = context.watch<LinkProvider>().posts;
    return Stack(children: [
      Positioned.fill(
        child: Container(color: Colors.white),
      ),
      Positioned.fill(
        child: Image.asset(
          "assets/images/whitebg3.jpg",
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(0.4),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: PatrickHandSC(text: "Mga Posts", fontSize: 32),
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
        ),
        body: StreamBuilder(
            stream: _postsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No Posts Yet!"));
              }
              var posts = snapshot.data!.docs.map((doc) {
                return Link.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();

              posts.sort((a, b) => b.date.compareTo(a.date));

              return Scrollbar(
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return buildLinkPreview(posts[index]);
                    }),
              );
            }),
      ),
    ]);
  }

  Widget buildLinkPreview(Link link) {
    String url = link.url;
    return Container(
      height: 425,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          launchUrl(Uri.parse(url));
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => ShowPostDialog(link: link),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/icons/sandiwa_logo.png'),
                    radius: 20,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'UP Sandiwa Samahang Bulakenyo',
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        dateFormatter(link.date),
                        maxLines: 1,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnyLinkPreview.builder(
                link: url,
                itemBuilder: (context, metadata, imageProvider, _) => Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageProvider != null)
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                        )
                      else
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/icons/sandiwa_logo.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        metadata.title == null ||
                                metadata.title ==
                                    "UP Sandiwa Samahang Bulakenyo"
                            ? link.title
                            : metadata.title!
                                .replaceAll(
                                    'UP Sandiwa Samahang Bulakenyo on Instagram: "',
                                    '')
                                .replaceAll('\n', '...'),
                        style: GoogleFonts.patrickHand(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      metadata.title == null ||
                              metadata.title == "UP Sandiwa Samahang Bulakenyo"
                          ? Text(
                              link.url,
                              style: GoogleFonts.patrickHand(fontSize: 18),
                              maxLines: 3,
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
