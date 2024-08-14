import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:validator_regex/validator_regex.dart';

class MyTextField2 extends StatelessWidget {
  //HINGIAN NG INPUT SA USER
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int? maxLines;
  final bool? isNumber; //required
  final bool? isURL;
  final bool? isEmail;
  final bool? isPassword;
  final TextEditingController? password;
  final FocusNode? focusNode;

  const MyTextField2(
      {required this.controller,
      this.keyboardType,
      this.isNumber,
      this.maxLines,
      required this.obscureText,
      required this.hintText,
      this.isURL,
      this.isEmail,
      this.password,
      this.isPassword,
      this.focusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid input!";
          }
          if (isNumber != null) {
            if (double.tryParse(value) == null) {
              return "Please enter a number!";
            }
          }
          if (isURL != null && isURL == true) {
            if (!Validator.url(value)) {
              return "Please enter a valid link! Must have https://";
            }
          }
          if (isEmail != null && isEmail == true) {
            if (!Validator.email(value)) {
              return "Please enter a valid email!";
            }
          }
          if (isPassword != null && value.length < 6) {
            return "Password is less than 6 characters!";
          }
          if (password != null) {
            if (password!.text != value) {
              return "Doesn't Match!";
            }
          }
        },
        cursorColor: Colors.black,
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            top: 12,
            left: 14,
            right: 14,
            bottom: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Color(0xFF1A1A1A)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: hintText,
          hintStyle:
              GoogleFonts.patrickHand(color: Color(0xffA1A1A1), fontSize: 15),
        ),
        maxLines: maxLines ?? 1,
        style: GoogleFonts.patrickHand(
            color: Color(0xFF1A1A1A),
            fontSize:
                19), // appearance of the text being typed in the textfield
        keyboardType: keyboardType,
        keyboardAppearance: Brightness.dark,
      ),
    );
  }
}

class MyMultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  const MyMultiLineTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      constraints: BoxConstraints(
        maxHeight: 120, // Set the fixed height for the border container
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.multiline,
            maxLines: null, // Allow multiple lines
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none, // Remove the internal border
            ),
          ),
        ),
      ),
    );
  }
}
