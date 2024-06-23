import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDottedBorder extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final Icon icon;
  const MyDottedBorder(
      {required this.icon, this.onTap, required this.text, super.key});

  @override
  State<MyDottedBorder> createState() => _MyDottedBorderState();
}

class _MyDottedBorderState extends State<MyDottedBorder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Colors.black,
        radius: Radius.circular(10),
        strokeWidth: 2,
        dashPattern: [8, 7],
        child: Container(
          height: 90,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.icon,
              Text(
                widget.text,
                style: GoogleFonts.inter(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
