import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/imageBuffer.dart';
import 'package:sandiwapp/components/showMessageDialog.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class ViewAssignBalancePage extends StatefulWidget {
  final String email;
  const ViewAssignBalancePage({required this.email, super.key});

  @override
  State<ViewAssignBalancePage> createState() => _ViewAssignBalancePageState();
}

class _ViewAssignBalancePageState extends State<ViewAssignBalancePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _balanceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> resisStream =
        context.watch<UserProvider>().fetchUsers();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "View/Assign Balance",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PatrickHand(text: '"', fontSize: 16),
                    Icon(Icons.check_circle, size: 16),
                    PatrickHand(
                        text: '" before balance indicates acknowledged',
                        fontSize: 16),
                  ],
                ),
              ),
            ),
            StreamBuilder(
                stream: resisStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
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

                  users.sort((a, b) =>
                      a.name.toLowerCase().compareTo(b.name.toLowerCase()));

                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          // padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            splashColor: Color(0xFFEEEEEE),
                            onLongPress: () {
                              if (user.email != widget.email)
                                showDialog(
                                    context: context,
                                    builder: (context) => ShowMessageDialog(
                                        senderEmail: widget.email, user: user));
                            },
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          scrollable: true,
                                          backgroundColor: Colors.white,
                                          title: PatrickHand(
                                              text:
                                                  "Assign Balance to ${user.nickname}",
                                              fontSize: 24),
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        "Enter new balance",
                                                        style: blackText)),
                                                MyTextField2(
                                                    controller:
                                                        _balanceController,
                                                    obscureText: false,
                                                    isNumber: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    hintText: '')
                                              ],
                                            ),
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
                                                      : BlackButton(
                                                          text: "I-update",
                                                          onTap: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                              });
                                                              String message = await context
                                                                  .read<
                                                                      UserProvider>()
                                                                  .updateBalance(
                                                                      user.id!,
                                                                      _balanceController
                                                                          .text);
                                                              if (message ==
                                                                  "") {
                                                                showCustomSnackBar(
                                                                    context,
                                                                    "${user.nickname}'s balance is updated",
                                                                    30);
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                _balanceController
                                                                    .clear();
                                                              } else {
                                                                showCustomSnackBar(
                                                                    context,
                                                                    "message",
                                                                    30);
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
                                      }));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              user.name,
                              style: GoogleFonts.patrickHand(fontSize: 16),
                            ),
                            leading: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child:
                                  user.photoUrl != "" && user.photoUrl != null
                                      ? ImageBuffer(
                                          photoURL: user.photoUrl!,
                                          height: 80,
                                          fit: BoxFit.contain,
                                          width: 80,
                                        )
                                      : Image.asset(
                                          'assets/images/base_image.png',
                                          height: 80,
                                          fit: BoxFit.contain,
                                          width: 80,
                                        ),
                            ),
                            trailing: Container(
                              width: 120,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  user.acknowledged
                                      ? const Icon(Icons.check_circle, size: 15)
                                      : Container(),
                                  const SizedBox(width: 3),
                                  Text(
                                    "Balance: P${double.parse(user.balance).toString()}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
