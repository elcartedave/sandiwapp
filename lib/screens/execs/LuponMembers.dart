import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/createTaskDialog.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/components/viewTasksDialog.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/users/ResidentsProfilePage.dart';

class LuponMembers extends StatefulWidget {
  final String lupon;
  const LuponMembers({required this.lupon, super.key});

  @override
  State<LuponMembers> createState() => _LuponMembersState();
}

class _LuponMembersState extends State<LuponMembers> {
  late Stream<QuerySnapshot> _membersStream;
  @override
  Widget build(BuildContext context) {
    if (widget.lupon.contains("Edukasyon")) {
      _membersStream = context.watch<UserProvider>().eduks;
    } else if (widget.lupon.contains("Pamamahayag")) {
      _membersStream = context.watch<UserProvider>().pubs;
    } else if (widget.lupon.contains("Pananalapi")) {
      _membersStream = context.watch<UserProvider>().fins;
    } else if (widget.lupon.contains("Kasapian")) {
      _membersStream = context.watch<UserProvider>().mems;
    } else {
      _membersStream = context.watch<UserProvider>().extes;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: PatrickHand(text: "${widget.lupon} Members", fontSize: 20),
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: _membersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Lupon Members"));
                  }
                  var luponMembers = snapshot.data!.docs.map((doc) {
                    return MyUser.fromJson(doc.data() as Map<String, dynamic>);
                  }).toList();

                  return ListView.builder(
                      itemCount: luponMembers.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final member = luponMembers[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResidentProfilePage(user: member)));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: member.photoUrl == null ||
                                              member.photoUrl == ""
                                          ? Image.asset(
                                              'assets/images/base_image.png',
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            )
                                          : ImageBuffer(
                                              photoURL: member.photoUrl!,
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        PatrickHand(
                                            text: member.name, fontSize: 20),
                                        const SizedBox(height: 10),
                                        WhiteButton(
                                          text: "View Tasks",
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    ViewTasks(user: member));
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        WhiteButton(
                                          text: "Assign Tasks",
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CreateTask(user: member));
                                          },
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
