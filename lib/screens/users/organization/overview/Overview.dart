import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/orgOverviewMenu.dart';
import 'package:sandiwapp/screens/users/organization/overview/Kasaysayan.dart';
import 'package:sandiwapp/screens/users/organization/overview/Konstitusyon.dart';

class OrgOverview extends StatefulWidget {
  const OrgOverview({super.key});

  @override
  State<OrgOverview> createState() => _OrgOverviewState();
}

class _OrgOverviewState extends State<OrgOverview> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
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
                      icon: Icons.folder,
                      text: "UPSSB Repository",
                      onTap: () {}),
                  OrgOverviewMenu(
                      icon: Icons.school, text: "Acad Drive", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
