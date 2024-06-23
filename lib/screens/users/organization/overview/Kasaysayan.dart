import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandiwapp/components/styles.dart';
import 'package:sandiwapp/screens/users/organization/overview/MemberPage.dart';
import 'package:sandiwapp/screens/users/organization/overview/UPSSBPage.dart';

class Kasaysayan extends StatefulWidget {
  const Kasaysayan({super.key});

  @override
  State<Kasaysayan> createState() => _KasaysayanState();
}

class _KasaysayanState extends State<Kasaysayan> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Color(0xFFEEEEEE),
        title: Text(
          "Kasaysayan",
          style: GoogleFonts.patrickHand(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
            child: ToggleButtons(
              isSelected: [selectedIndex == 0, selectedIndex == 1],
              onPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              borderRadius: BorderRadius.circular(20),
              borderColor: Colors.black,
              borderWidth: 2,
              selectedBorderColor: Colors.black,
              fillColor: Colors.black,
              selectedColor: Colors.white,
              color: Colors.black,
              constraints: BoxConstraints(minHeight: 30.0, minWidth: 100.0),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
                  child: Text("UPSSB",
                      style: GoogleFonts.patrickHand(fontSize: 15)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
                  child: Text("Talaan ng Miyembro",
                      style: GoogleFonts.patrickHand(fontSize: 15)),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: [
                UPSSBPage(),
                MemberPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
