import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class ConfirmMemberPage extends StatefulWidget {
  const ConfirmMemberPage({super.key});

  @override
  State<ConfirmMemberPage> createState() => _ConfirmMemberPageState();
}

class _ConfirmMemberPageState extends State<ConfirmMemberPage> {
  final List<String> designation = [
    "Aplikante",
    "Resi-Lupon ng Edukasyon at Pananaliksik",
    "Resi-Lupon ng Pamamahayag at Publikasyon",
    "Resi-Lupon ng Kasapian",
    "Resi-Lupon ng Pananalapi",
    "Resi-Lupon ng Ugnayang Panlabas",
    "Head-Lupon ng Edukasyon at Pananaliksik",
    "Head-Lupon ng Pamamahayag at Publikasyon",
    "Head-Lupon ng Kasapian",
    "Head-Lupon ng Pananalapi",
    "Head-Lupon ng Ugnayang Panlabas",
    "Sec-Lupon ng Edukasyon at Pananaliksik",
    "Sec-Lupon ng Pamamahayag at Publikasyon",
    "Sec-Lupon ng Kasapian",
    "Sec-Lupon ng Pananalapi",
    "Sec-Lupon ng Ugnayang Panlabas",
    "VP-Lupon ng Edukasyon at Pananaliksik",
    "VP-Lupon ng Pamamahayag at Publikasyon",
    "VP-Lupon ng Kasapian",
    "VP-Lupon ng Pananalapi",
    "VP-Lupon ng Ugnayang Panlabas",
    "Pres-Lupon ng Edukasyon at Pananaliksik",
    "Pres-Lupon ng Pamamahayag at Publikasyon",
    "Pres-Lupon ng Kasapian",
    "Pres-Lupon ng Pananalapi",
    "Pres-Lupon ng Ugnayang Panlabas",
  ];

  // List to store selected designation for each user
  List<String?> _selectedDesignations = [];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> pendingUsersStream =
        context.watch<UserProvider>().pendingUsers;
    Stream<QuerySnapshot> applicantsStream =
        context.watch<UserProvider>().applicants;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PatrickHand(text: "Pending Users", fontSize: 20),
            StreamBuilder(
              stream: pendingUsersStream,
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
                  return SizedBox(
                      height: 100,
                      child: Center(child: Text("No Pending Users")));
                }
                var pendingMembers = snapshot.data!.docs.map((doc) {
                  return MyUser.fromJson(doc.data() as Map<String, dynamic>);
                }).toList();

                // Update _selectedDesignations list size
                if (_selectedDesignations.length != pendingMembers.length) {
                  _selectedDesignations =
                      List<String?>.filled(pendingMembers.length, null);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pendingMembers.length,
                  itemBuilder: (context, index) {
                    final pendingMember = pendingMembers[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                pendingMember.photoUrl == null ||
                                        pendingMember.photoUrl == ""
                                    ? Image.asset(
                                        'assets/images/base_image.png',
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        pendingMember.photoUrl!,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                PatrickHand(
                                    text: pendingMember.name, fontSize: 20)
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<String>(
                                  hint: Text("Designation", style: blackText),
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: _selectedDesignations[index],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      top: 12,
                                      left: 14,
                                      right: 14,
                                      bottom: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Color(0xFF1A1A1A)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.red),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedDesignations[index] = newValue;
                                    });
                                  },
                                  items: designation.map((designationItem) {
                                    return DropdownMenuItem(
                                      value: designationItem,
                                      child: Text(
                                        designationItem,
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  validator: (value) => value == null
                                      ? 'Please select a designation'
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                BlackButton(
                                    text: "Accept",
                                    onTap: () async {
                                      if (_selectedDesignations[index] !=
                                          null) {
                                        await context
                                            .read<UserProvider>()
                                            .acceptAndAddLupon(
                                                pendingMember.email,
                                                _selectedDesignations[index]!);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              'Please select a designation.',
                                              style: blackText,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                const SizedBox(height: 5),
                                WhiteButton(
                                  text: "Reject",
                                  onTap: () async {
                                    await context
                                        .read<UserProvider>()
                                        .rejectAndDelete(pendingMember.email);
                                  },
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            PatrickHand(text: "Applicants", fontSize: 20),
            StreamBuilder(
              stream: applicantsStream,
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
                  return SizedBox(
                      height: 100, child: Center(child: Text("No Applicants")));
                }
                var applicants = snapshot.data!.docs.map((doc) {
                  return MyUser.fromJson(doc.data() as Map<String, dynamic>);
                }).toList();

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          applicant.photoUrl == null || applicant.photoUrl == ""
                              ? Image.asset(
                                  'assets/images/base_image.png',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  applicant.photoUrl!,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(height: 10),
                          PatrickHand(text: applicant.name, fontSize: 20),
                          // Add any specific handling for applicants if needed
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
