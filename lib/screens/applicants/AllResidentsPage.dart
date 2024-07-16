import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/sampleCard.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class AllResidentsPage extends StatefulWidget {
  const AllResidentsPage({super.key});

  @override
  State<AllResidentsPage> createState() => _AllResidentsPageState();
}

class _AllResidentsPageState extends State<AllResidentsPage> {
  Map<String, List<MyUser>> groupByLupon(List<MyUser> users) {
    SplayTreeMap<String, List<MyUser>> groupedUsers = SplayTreeMap();
    for (var user in users) {
      if (user.lupon != null) {
        if (groupedUsers.containsKey(user.lupon)) {
          groupedUsers[user.lupon]!.add(user);
        } else {
          groupedUsers[user.lupon!] = [user];
        }
      }
    }
    return groupedUsers;
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream =
        context.watch<UserProvider>().fetchUsers();
    return Stack(children: [
      Positioned.fill(
        child: Container(color: Colors.white),
      ),
      Positioned.fill(
        child: Image.asset(
          "assets/images/whitebg.jpg",
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(0.5),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: PatrickHandSC(text: "Mga Residente", fontSize: 32),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
              stream: _usersStream,
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
                  return Center(child: Text("No Users"));
                }

                List<MyUser> users = snapshot.data!.docs.map((doc) {
                  return MyUser.fromJson(doc.data() as Map<String, dynamic>);
                }).toList();

                Map<String, List<MyUser>> groupedUsers = groupByLupon(users);
                return ListView(
                  children: groupedUsers.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: PatrickHand(text: entry.key, fontSize: 16),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: entry.value.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 3,
                          ),
                          itemBuilder: (context, index) {
                            MyUser user = entry.value[index];
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                              child: SampleCard(
                                user: user,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    ]);
  }
}
