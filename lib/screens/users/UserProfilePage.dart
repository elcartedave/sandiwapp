import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/editProfileDialog.dart';
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
  bool _isEditMode = false; // New variable to track edit mode

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
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: 5, bottom: 10, left: 25, right: 25),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 15),
            StreamBuilder(
                stream: _userStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error fetching user data"));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text("User data not available"));
                  }
                  MyUser user = MyUser.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>);
                  return Column(
                    children: [
                      buildProfileHeader(user),
                      const SizedBox(height: 10),
                      buildEditSwitch(),
                      buildInfoCard(user),
                      const SizedBox(height: 15),
                      buildActionCard(user),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget buildActionCard(MyUser user) {
    return Card(
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
              await context.read<UserAuthProvider>().authService.signOut();
            },
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(MyUser user) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow("Nickname:", user.nickname, _isEditMode),
            buildInfoRow("Email:", user.email, false),
            buildInfoRow("Birthday:", user.birthday, false),
            buildInfoRow("Age:", calculateAge(user.birthday), false),
            buildInfoRow("Contact Number:", user.contactno, _isEditMode),
            buildInfoRow("Degree Program:", user.degprog, _isEditMode),
            buildInfoRow("College Address:", user.collegeAddress, _isEditMode),
            buildInfoRow("Home Address:", user.homeAddress, _isEditMode),
            buildInfoRow("Sponsor:", user.sponsor, false),
            buildInfoRow("Batch:", user.batch, false),
          ],
        ),
      ),
    );
  }

  Widget buildEditSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Edit Profile',
          style: GoogleFonts.patrickHand(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Switch(
            inactiveThumbColor: Colors.grey.shade700,
            activeColor: Colors.white,
            activeTrackColor: Colors.grey.shade700,
            inactiveTrackColor: Colors.white,
            value: _isEditMode,
            onChanged: (value) {
              setState(() {
                _isEditMode = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildProfileHeader(MyUser user) {
    return Row(
      children: [
        Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(5100)),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(50), // Image radius
                child: user.photoUrl == "" || user.photoUrl == null
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
            child: !_isEditMode
                ? Container()
                : GestureDetector(
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
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: SingleChildScrollView(
                                                  child: CachedNetworkImage(
                                                imageUrl: user.photoUrl!,
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
                                                          color: Colors.black,
                                                          value:
                                                              downloadProgress
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
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: SingleChildScrollView(
                                                  child: Image.file(_image!)),
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
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : _isLoading
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    : BlackButton(
                                                        text: "I-Update",
                                                        onTap: () async {
                                                          if (_image == null) {
                                                            showCustomSnackBar(
                                                                context,
                                                                "No new image uploaded!",
                                                                85);
                                                          } else {
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            String message =
                                                                await context
                                                                    .read<
                                                                        UserProvider>()
                                                                    .addPhoto(
                                                                        _image!,
                                                                        user.photoUrl!);
                                                            if (message == "") {
                                                              showCustomSnackBar(
                                                                  context,
                                                                  "Profile updated successfully",
                                                                  85);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
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
                                                  Navigator.of(context).pop();
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
                style: GoogleFonts.inter(color: Colors.white, fontSize: 28),
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
    );
  }

  Widget buildInfoRow(String label, String value, bool editable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // start both vertically
        children: [
          Text(
            "$label ",
            style: GoogleFonts.patrickHand(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: editable
                  ? GestureDetector(
                      key: ValueKey('editable_$label'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                EditProfileDialog(type: label, content: value));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.black),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            key: ValueKey('non_editable_$label'),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
