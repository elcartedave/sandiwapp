import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/models/userModel.dart';

class ResidentProfilePage extends StatefulWidget {
  final MyUser user;
  const ResidentProfilePage({required this.user, super.key});

  @override
  State<ResidentProfilePage> createState() => _ResidentProfilePageState();
}

class _ResidentProfilePageState extends State<ResidentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add Scaffold to provide Material context
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/sandiwa_cover.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(180),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.045,
                      child: Image.asset(
                        'assets/icons/sandiwa_logo_white.png',
                        height: 150,
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.22,
                      child: Container(
                        decoration: widget.user.photoUrl == ""
                            ? null
                            : BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.black,
                          child: widget.user.photoUrl != ""
                              ? null
                              : const Icon(
                                  Icons.account_circle,
                                  size: 150,
                                  color: Colors.white,
                                ),
                          backgroundImage: widget.user.photoUrl == ""
                              ? null
                              : NetworkImage(widget.user.photoUrl!),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Text(
                  widget.user.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildDetailRow('Nickname:', widget.user.nickname),
                          buildDetailRow('Birthday:', widget.user.birthday),
                          buildDetailRow('Age:', widget.user.age),
                          buildDetailRow(
                              'College Address:', widget.user.collegeAddress),
                          buildDetailRow(
                              'Home Address:', widget.user.homeAddress),
                          buildDetailRow('Sponsor:', widget.user.sponsor),
                          buildDetailRow('Batch:', widget.user.batch),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: GoogleFonts.patrickHand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
