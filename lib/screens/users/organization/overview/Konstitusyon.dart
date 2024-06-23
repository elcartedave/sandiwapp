import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/pdfViewer.dart';

class Konstitusyon extends StatefulWidget {
  const Konstitusyon({super.key});

  @override
  State<Konstitusyon> createState() => _KonstitusyonState();
}

class _KonstitusyonState extends State<Konstitusyon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Konstitusyon",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: PDFViewer(),
    );
  }
}
