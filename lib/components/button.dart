import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/styles.dart';

class BlackButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const BlackButton({required this.text, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          text,
          style: whiteText,
        )),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyTextButton({required this.text, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: blackText,
      ),
    );
  }
}
