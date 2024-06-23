import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatrickHand extends StatelessWidget {
  final String text;
  final int fontSize;
  const PatrickHand({required this.text, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.patrickHand(fontSize: fontSize.toDouble()),
    );
  }
}

class PatrickHandSC extends StatelessWidget {
  final String text;
  final int fontSize;
  const PatrickHandSC({required this.text, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.patrickHandSc(fontSize: fontSize.toDouble()),
    );
  }
}
