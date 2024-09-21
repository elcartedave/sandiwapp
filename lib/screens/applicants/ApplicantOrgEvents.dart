import 'package:flutter/material.dart';
import 'package:sandiwapp/components/texts.dart';

class Applicantorgevents extends StatelessWidget {
  Applicantorgevents({super.key});
  final List imageNames = [
    "pic1.jpg",
    "pic2.jpg",
    "pic3.jpg",
    "pic4.jpg",
    "pic5.jpg",
    "pic6.jpg",
    "pic7.jpg",
    "pic8.jpg",
    "pic9.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: PatrickHandSC(text: 'Mga Gawain ng Organisasyon', fontSize: 24),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: imageNames.map((imageName) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/${imageName}",
                fit: BoxFit.contain, // Adjust the image fit as necessary
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
