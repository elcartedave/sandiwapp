import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/scrollDownAnimation.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/components/uploadImage.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_auth_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class UserProfilePage extends StatefulWidget {
  final bool? isApplicant;
  const UserProfilePage({this.isApplicant, super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  File? _image;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImageAndScroll() async {
    File? pickedImage = await pickerImage();
    setState(() {
      _image = pickedImage;
    });
    if (_image != null) {
      scrollToEnd(_scrollController);
    }
  }

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
              color: Colors.white,
            ));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching user data"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            context.read<UserAuthProvider>().signOut();
            return Center(child: Text("User data not available"));
          }
          MyUser user =
              MyUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          return Container(
            height: double.infinity,
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 25, right: 25),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5100)),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(50), // Image radius
                              child:
                                  user.photoUrl == "" || user.photoUrl == null
                                      ? Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 100,
                                        )
                                      : ImageBuffer(
                                          photoURL: user.photoUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 7,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            scrollable: true,
                                            title: PatrickHand(
                                              text: "Update Profile Picture",
                                              fontSize: 24,
                                            ),
                                            content: Column(
                                              children: [
                                                WhiteButton(
                                                  text: "Add Photo",
                                                  onTap: () async {
                                                    File? pickedImage =
                                                        await pickerImage();
                                                    setState(() {
                                                      _image = pickedImage;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 15),
                                                if (user.photoUrl! != "" &&
                                                    _image == null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                      child:
                                                          SingleChildScrollView(
                                                              child:
                                                                  CachedNetworkImage(
                                                        imageUrl:
                                                            user.photoUrl!,
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                SizedBox(
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                  value: downloadProgress
                                                                      .progress,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                if (_image != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.4,
                                                      child:
                                                          SingleChildScrollView(
                                                              child: Image.file(
                                                                  _image!)),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: _isLoading
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          )
                                                        : _isLoading
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : BlackButton(
                                                                text:
                                                                    "I-Update",
                                                                onTap:
                                                                    () async {
                                                                  if (_image ==
                                                                      null) {
                                                                    showCustomSnackBar(
                                                                        context,
                                                                        "No new image uploaded!",
                                                                        85);
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          true;
                                                                    });
                                                                    String message = await context
                                                                        .read<
                                                                            UserProvider>()
                                                                        .addPhoto(
                                                                            _image!,
                                                                            user.photoUrl!);
                                                                    if (message ==
                                                                        "") {
                                                                      showCustomSnackBar(
                                                                          context,
                                                                          "Profile updated successfully",
                                                                          85);
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                    } else {
                                                                      showCustomSnackBar(
                                                                          context,
                                                                          message,
                                                                          85);
                                                                    }
                                                                  }
                                                                },
                                                              ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Center(
                                                      child: WhiteButton(
                                                        text: "Bumalik",
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ));
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 28),
                            ),
                            Text(
                              user.position!,
                              style: GoogleFonts.judson(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic),
                            ),
                            user.position!.contains("Aplikante") ||
                                    user.position!.contains("Pinuno")
                                ? Container()
                                : Text(
                                    user.lupon!,
                                    style: GoogleFonts.judson(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoRow("Nickname:", user.nickname),
                          buildInfoRow("Email:", user.email),
                          buildInfoRow("Birthday:", user.birthday),
                          buildInfoRow("Age:", user.age),
                          buildInfoRow("Contact Number:", user.contactno),
                          buildInfoRow("Degree Program:", user.degprog),
                          buildInfoRow("College Address:", user.collegeAddress),
                          buildInfoRow("Home Address:", user.homeAddress),
                          buildInfoRow("Sponsor:", user.sponsor),
                          buildInfoRow("Batch:", user.batch),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text(
                            "About",
                            style: GoogleFonts.patrickHandSc(fontSize: 24),
                          ),
                          onTap: () {
                            // Handle About tap
                          },
                          trailing: Icon(Icons.navigate_next),
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text(
                            "Log Out",
                            style: GoogleFonts.patrickHandSc(fontSize: 24),
                          ),
                          onTap: () async {
                            if (widget.isApplicant != null) {
                              Navigator.pop(context);
                            }
                            await context
                                .read<UserAuthProvider>()
                                .authService
                                .signOut();
                          },
                          trailing: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: GoogleFonts.patrickHand(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
