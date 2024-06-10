import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField2 extends StatelessWidget {
  //HINGIAN NG INPUT SA USER
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField2(
      {required this.controller,
      required this.obscureText,
      required this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid input!";
          }
        },
        cursorColor: Colors.black,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 12,
            left: 14,
            right: 48,
            bottom: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: hintText,
          hintStyle:
              GoogleFonts.patrickHand(color: Color(0xffA1A1A1), fontSize: 15),
        ),
        style: GoogleFonts.patrickHand(
            color: Color(0xFF1A1A1A),
            fontSize:
                19), // appearance of the text being typed in the textfield
      ),
    );
  }
}
