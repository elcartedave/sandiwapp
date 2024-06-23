import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/bulletList.dart';

class UPSSBPage extends StatefulWidget {
  const UPSSBPage({super.key});

  @override
  State<UPSSBPage> createState() => _UPSSBPageState();
}

class _UPSSBPageState extends State<UPSSBPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Image.asset('assets/icons/sandiwa_logo.png', width: 300),
            const SizedBox(height: 15),
            Text(
              "Ang UP Sandiwa Samahang Bulakenyo ay isang varsitarian oganization ng itinatag noong 1994. ",
              style: TextStyle(fontFamily: 'Inter', fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              "Mga Kulay/Sagisag",
              style: GoogleFonts.patrickHandSc(fontSize: 24),
              textAlign: TextAlign.start,
            ),
            Container(
              child: BulletList([
                "Ang UP Sandiwa Samahang Bulakenyo ay isang varsitarian oganization ng itinatag noong 1994. ",
                "Ang UP Sandiwa Samahang Bulakenyo ay isang varsitarian oganization ng itinatag noong 1994. ",
                "Ang UP Sandiwa Samahang Bulakenyo ay isang varsitarian oganization ng itinatag noong 1994. ",
              ]),
            ),
            const SizedBox(height: 15),
            Text(
              "Preambulo",
              style: GoogleFonts.patrickHandSc(fontSize: 24),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
