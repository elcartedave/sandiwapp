import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/statement_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';
import 'package:sandiwapp/screens/users/dashboard/CreateStatement.dart';

class ViewStatementPage extends StatefulWidget {
  const ViewStatementPage({super.key});

  @override
  State<ViewStatementPage> createState() => _ViewStatementPageState();
}

class _ViewStatementPageState extends State<ViewStatementPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _statementStream =
        context.watch<StatementProvider>().finalStatements;
    Stream<QuerySnapshot> _userStream = context.watch<UserProvider>().users;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "View Statements",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: StreamBuilder(
        stream: _statementStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Statements"));
          }
          var drafts = snapshot.data!.docs.map((doc) {
            return Statement.fromJson(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
          drafts.sort((a, b) => b.date.compareTo(a.date));
          return StreamBuilder(
            stream: _userStream,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.black));
              }
              if (userSnapshot.hasError) {
                return Center(child: Text("Error: ${userSnapshot.error}"));
              }
              if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Users"));
              }
              List<MyUser> users = userSnapshot.data!.docs.map((doc) {
                return MyUser.fromJson(doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.builder(
                itemCount: drafts.length,
                itemBuilder: (context, index) {
                  final draft = drafts[index];
                  MyUser? getUserById(String id) {
                    for (var user in users) {
                      if (user.id == id) {
                        return user;
                      }
                    }
                    return null;
                  }

                  final user = getUserById(draft.senderId);
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateStatement(
                                    isPinuno: true,
                                    statement: draft,
                                  )));
                    },
                    leading: Text(user != null ? user.nickname : 'Unknown'),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            draft.title,
                            style: GoogleFonts.patrickHand(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            draft.content,
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: draft.status != "Pending"
                        ? Text(draft.status, style: TextStyle(fontSize: 12))
                        : SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.3, // Adjust the width as needed
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    String message = await context
                                        .read<StatementProvider>()
                                        .toggleStatus(draft.id!, true);
                                    if (message == '') {
                                      showCustomSnackBar(
                                          context, "Statement approved!", 30);
                                    } else {
                                      showCustomSnackBar(context, message, 30);
                                    }
                                  },
                                  child: const Icon(Icons.check, size: 40),
                                ),
                                InkWell(
                                    onTap: () async {
                                      String message = await context
                                          .read<StatementProvider>()
                                          .toggleStatus(draft.id!, false);
                                      if (message == '') {
                                        showCustomSnackBar(
                                            context, "Statement rejected!", 30);
                                      } else {
                                        showCustomSnackBar(
                                            context, message, 30);
                                      }
                                    },
                                    child: const Icon(Icons.close, size: 40)),
                              ],
                            ),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
