import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/adminSampleCard.dart';
import 'package:sandiwapp/components/sampleCard.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class AdminOrgResidents extends StatefulWidget {
  const AdminOrgResidents({super.key});

  @override
  State<AdminOrgResidents> createState() => _AdminOrgResidentsState();
}

class _AdminOrgResidentsState extends State<AdminOrgResidents> {
  // Function to group users by lupon
  Map<String, List<MyUser>> groupByLupon(List<MyUser> users) {
    Map<String, List<MyUser>> groupedUsers = {};
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
    Stream<QuerySnapshot> _usersStream = context.watch<UserProvider>().users;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              child: PatrickHand(text: "Mga Residente", fontSize: 33)),
          Expanded(
            child: StreamBuilder(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      MediaQuery.of(context).size.height *
                                      1.3,
                            ),
                            itemBuilder: (context, index) {
                              MyUser user = entry.value[index];
                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                child: AdminSampleCard(
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
        ],
      ),
    );
  }
}
