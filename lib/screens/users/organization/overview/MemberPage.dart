import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/bulletList.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        children: [
          Text("Founding Fathers",
              style: GoogleFonts.patrickHandSc(fontSize: 24)),
          BulletList([
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
          ]),
          const SizedBox(height: 20),
          Text("Unang Batch", style: GoogleFonts.patrickHandSc(fontSize: 24)),
          BulletList([
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
            "Juan Dela Cruz",
          ])
        ],
      )),
    );
  }
}
