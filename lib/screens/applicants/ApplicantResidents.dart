import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/users/ResidentsProfilePage.dart';

class ApplicantResidents extends StatefulWidget {
  const ApplicantResidents({super.key});

  @override
  State<ApplicantResidents> createState() => _ApplicantResidentsState();
}

class _ApplicantResidentsState extends State<ApplicantResidents> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStream =
        context.watch<UserProvider>().fetchUsers();
    return Container(
      height: 150,
      child: StreamBuilder(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.black));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }
            List<MyUser> users = snapshot.data!.docs.map((doc) {
              return MyUser.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ResidentProfilePage(user: users[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                          child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: users[index].photoUrl != ""
                                  ? null
                                  : const Icon(
                                      Icons.account_circle,
                                      size: 110,
                                      color: Colors.black,
                                    ),
                              backgroundImage: users[index].photoUrl != ""
                                  ? NetworkImage(users[index].photoUrl!)
                                  : null),
                          const SizedBox(height: 5),
                          Text(
                            users[index].name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          PatrickHand(text: users[index].nickname, fontSize: 12)
                        ],
                      )),
                    ),
                  );
                });
          }),
    );
  }
}
