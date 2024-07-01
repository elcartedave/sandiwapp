import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sandiwapp/components/button.dart';
import 'package:sandiwapp/components/customSnackbar.dart';
import 'package:sandiwapp/components/textfield.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/providers/announcement_provider.dart';

class CreateAnnouncementPage extends StatefulWidget {
  final String type;
  const CreateAnnouncementPage({required this.type, super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Gumawa ng Anunsyo",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  PatrickHandSC(text: "Title", fontSize: 20),
                  MyTextField2(
                      controller: _titleController,
                      obscureText: false,
                      hintText: ''),
                  const SizedBox(height: 15),
                  Container(
                      alignment: Alignment.topLeft,
                      child: PatrickHandSC(text: "Content", fontSize: 20)),
                  MyTextField2(
                    controller: _contentController,
                    obscureText: false,
                    hintText: '',
                    maxLines: 8,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          )),
        ),
        _isLoading
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlackButton(
                  text: "I-ANNOUNCE",
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      String message = await context
                          .read<AnnouncementProvider>()
                          .createAnnouncement(_titleController.text,
                              _contentController.text, widget.type);
                      if (message == "") {
                        showCustomSnackBar(
                            context, "Announcement successfully created!", 85);
                      } else {
                        showCustomSnackBar(context, message, 85);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              )
      ]),
    );
  }
}
