import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/addPostDialog.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/deletePostDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/linksModel.dart';
import 'package:sandiwapp/providers/link_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgPosts extends StatefulWidget {
  const OrgPosts({super.key});

  @override
  State<OrgPosts> createState() => _OrgPostsState();
}

class _OrgPostsState extends State<OrgPosts> {
  bool isPinuno = false;

  @override
  Widget build(BuildContext context) {
    Future<bool> isCurrentPinuno =
        context.read<UserProvider>().isCurrentPinuno();
    Stream<QuerySnapshot> _postsStream =
        context.watch<LinkProvider>().fetchPosts();

    return Container(
      padding: const EdgeInsets.fromLTRB(4, 16, 8, 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: PatrickHand(text: "Mga Posts", fontSize: 33),
                ),
              ),
              const SizedBox(width: 5),
              FutureBuilder<bool>(
                future: isCurrentPinuno,
                builder: (context, pinunoSnapshot) {
                  if (pinunoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }
                  if (pinunoSnapshot.data == true) {
                    isPinuno = true;
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddPost(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          padding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                return ListWheelScrollView.useDelegate(
                  diameterRatio: 3,
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: posts.length,
                      builder: (context, index) =>
                          buildLinkPreview(posts[index])),
                  itemExtent: MediaQuery.of(context).size.height * 0.55,
                  physics: FixedExtentScrollPhysics(),
                  scrollBehavior: ScrollBehavior(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLinkPreview(Link link) {
    String url = link.url;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: GestureDetector(
        onTap: () {
          launchUrl(Uri.parse(url));
        },
        onLongPress: () {
          if (isPinuno) {
            showDialog(
                context: context,
                builder: (context) => ShowPostDialog(link: link));
          }
        },
        child: AnyLinkPreview.builder(
          key: UniqueKey(),
          link: url,
          itemBuilder: (context, metadata, imageProvider, _) => Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (imageProvider != null)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                  )
                else
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/icons/sandiwa_logo.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      metadata.title == null ||
                              metadata.title == "UP Sandiwa Samahang Bulakenyo"
                          ? Text(
                              link.title,
                              style: GoogleFonts.patrickHand(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              metadata.title!
                                  .replaceAll(
                                      'UP Sandiwa Samahang Bulakenyo on Instagram: "',
                                      '')
                                  .replaceAll('\n', '...'),
                              style: GoogleFonts.patrickHand(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                      const SizedBox(height: 5),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        dateFormatter(link.date),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        url,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
