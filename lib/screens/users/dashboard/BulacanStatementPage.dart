import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/dateformatter.dart';
import 'package:sandiwapp/components/deleteStatementDialog.dart';
import 'package:sandiwapp/components/showStatementDialog.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/statementModel.dart';
import 'package:sandiwapp/providers/statement_provider.dart';
import 'package:sandiwapp/screens/users/dashboard/CreateStatement.dart';

class BulacanStatementPage extends StatefulWidget {
  const BulacanStatementPage({super.key});

  @override
  State<BulacanStatementPage> createState() => _BulacanStatementPageState();
}

class _BulacanStatementPageState extends State<BulacanStatementPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _mydraftsStream =
        context.watch<StatementProvider>().fetchDraftStatements();
    Stream<QuerySnapshot> _myfinalsStream =
        context.watch<StatementProvider>().fetchMyFinalStatements();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: PatrickHand(text: "Bulacan Statements", fontSize: 20),
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlackButton(
                text: "Add A Draft",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateStatement()));
                },
              ),
              const SizedBox(height: 10),
              PatrickHand(text: "My Drafts", fontSize: 24),
              StreamBuilder(
                stream: _mydraftsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child:
                          const Center(child: Text("You Have No Drafts Yet!")),
                    );
                  }
                  var drafts = snapshot.data!.docs.map((doc) {
                    return Statement.fromJson(
                      doc.data() as Map<String, dynamic>,
                    );
                  }).toList();
                  drafts.sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: drafts.length,
                    itemBuilder: (context, index) {
                      final draft = drafts[index];
                      return ListTile(
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  DeleteDialog(statement: draft));
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateStatement(
                                        statement: draft,
                                      )));
                        },
                        title: PatrickHand(text: draft.title, fontSize: 16),
                        trailing: SizedBox(
                            width: 100, // Adjust the width as needed
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : BlackButton(
                                    text: "Submit",
                                    onTap: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      String message = await context
                                          .read<StatementProvider>()
                                          .submit(draft.id!, true);
                                      if (message == "") {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        showCustomSnackBar(
                                            context,
                                            "Statement submitted to head for approval",
                                            30);
                                      } else {
                                        showCustomSnackBar(
                                            context, message, 30);
                                      }
                                    },
                                  )),
                        subtitle: Text(
                          draft.content,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              PatrickHand(text: "Sent to Head", fontSize: 24),
              StreamBuilder(
                stream: _myfinalsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {}
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: const Center(child: Text("Empty!")),
                    );
                  }
                  var docs = snapshot.data!.docs.map((doc) {
                    return Statement.fromJson(
                      doc.data() as Map<String, dynamic>,
                    );
                  }).toList();
                  docs.sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final statement = docs[index];
                      return ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  ShowStatementDialog(statement: statement));
                        },
                        leading: Text(shortDateFormatter(statement.date)),
                        title: PatrickHand(text: statement.title, fontSize: 16),
                        trailing: Text(
                          statement.status,
                          style: TextStyle(fontSize: 12),
                        ),
                        subtitle: Text(
                          statement.content,
                          textAlign: TextAlign.justify,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
