import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/orgOverviewMenu.dart';
import 'package:sandiwapp/screens/execs/Minutes.dart';
import 'package:sandiwapp/screens/users/organization/overview/Kasaysayan.dart';
import 'package:sandiwapp/screens/users/organization/overview/Konstitusyon.dart';
import 'package:url_launcher/url_launcher.dart';

class OrgOverview extends StatefulWidget {
  const OrgOverview({super.key});

  @override
  State<OrgOverview> createState() => _OrgOverviewState();
}

class _OrgOverviewState extends State<OrgOverview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "UP SANDIWA SAMAHANG BULAKENYO",
            style: GoogleFonts.patrickHand(fontSize: 40),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              children: [
                OrgOverviewMenu(
                    icon: Icons.search,
                    text: "Kasaysayan",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Kasaysayan()));
                    }),
                OrgOverviewMenu(
                    icon: Icons.book,
                    text: "Konstitusyon",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Konstitusyon()));
                    }),
                OrgOverviewMenu(
                    icon: Icons.folder, text: "UPSSB Repository", onTap: () {}),
                OrgOverviewMenu(
                    icon: Icons.school,
                    text: "Acad Drive",
                    onTap: () {
                      launchUrl(Uri.parse(
                          "https://drive.google.com/drive/folders/1U5TnT6UZLNR0yODkm2f4CSt3p-Hkzf6M?usp=drive_link"));
                    }),
                OrgOverviewMenu(
                    icon: Icons.list,
                    text: "Minutes of the Meetings",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Minutes(
                                    isPinuno: false,
                                  )));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
