import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/models/userModel.dart';
import 'package:sandiwapp/providers/message_provider.dart';
import 'package:sandiwapp/providers/user_provider.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final List<String> lupon = [
    "Pinuno ng Lupon ng Edukasyon at Pananaliksik",
    "Pinuno ng Lupon ng Pamamahayag at Publikasyon",
    "Pinuno ng Lupon ng Kasapian",
    "Pinuno ng Lupon ng Pananalapi",
    "Pinuno ng Lupon ng Ugnayang Panlabas",
    "Pangkalahatang Kalihim",
    "Ikalawang Tagapangulo",
    "Tagapangulo",
  ];
  String? _selectedLupon;
  late String id;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream =
        context.watch<UserProvider>().fetchCurrentUser();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Magpadala ng Mensahe:",
        style: GoogleFonts.patrickHand(color: Colors.black, fontSize: 30),
        textAlign: TextAlign.left,
      ),
      content: Form(
        key: _formKey,
        child: StreamBuilder(
            stream: _userStream,
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(child: Text("Error: ${userSnapshot.error}"));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return Center(child: Text("User data not found"));
              }

              MyUser user = MyUser.fromJson(
                  userSnapshot.data!.data() as Map<String, dynamic>);
              id = userSnapshot.data!.id;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("TO:", style: blackText),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            hint: Text(
                              "Enter a recipient",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                            dropdownColor: Colors.white,
                            isExpanded: true,
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
                                borderSide:
                                    BorderSide(width: 2, color: Colors.red),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.red),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            value: _selectedLupon,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLupon = newValue;
                              });
                            },
                            items: lupon.map((luponItem) {
                              return DropdownMenuItem(
                                value: luponItem,
                                child: Text(
                                  luponItem,
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select a recipient'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text("MESSAGE:", style: blackText),
                    MyTextField2(
                      controller: _messageController,
                      obscureText: false,
                      hintText: "Magpadala ng mensahe",
                      maxLines: 5,
                    ),
                  ],
                ),
              );
            }),
      ),
      actions: [
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : BlackButton(
                text: "Ipadala",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    String? result = await context
                        .read<MessageProvider>()
                        .sendMessage(
                            id, _messageController.text, _selectedLupon!);
                    if (result == null || result == "") {
                      showCustomSnackBar(context, "Message sent", 100);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(result)));
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyTextButton(
              text: "Bumalik",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        )
      ],
    );
  }
}
