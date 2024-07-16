import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicantGrid extends StatefulWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String text;

  const ApplicantGrid({
    required this.text,
    this.icon,
    required this.onTap,
    super.key,
  });

  @override
  State<ApplicantGrid> createState() => _ApplicantGridState();
}

class _ApplicantGridState extends State<ApplicantGrid> {
  bool isPressed = false;

  void _handleTap() {
    setState(() {
      isPressed = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isPressed = false;
      });
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 50),
        transform:
            Matrix4.translationValues(isPressed ? 4 : 0, isPressed ? 4 : 0, 0),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: isPressed ? Offset(0, 0) : Offset(4, 4),
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
