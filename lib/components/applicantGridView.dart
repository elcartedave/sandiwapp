import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicantGrid extends StatefulWidget {
  final Function()? onTap;
  final IconData? icon;
  final String text;
  const ApplicantGrid({required this.text, this.icon, this.onTap, super.key});

  @override
  State<ApplicantGrid> createState() => _ApplicantGridState();
}

class _ApplicantGridState extends State<ApplicantGrid> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: Offset(4, 4), // Shadow position
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 40, color: Colors.black),
              Text(
                widget.text,
                style: GoogleFonts.patrickHandSc(
                    fontSize: 16, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
