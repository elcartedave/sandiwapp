import 'package:flutter/material.dart';
import 'package:sandiwapp/components/animatedButton.dart';
import 'package:sandiwapp/components/texts.dart';
import 'package:sandiwapp/screens/users/organization/overview/Konstitusyon.dart';

class ApplicantOrgPage extends StatefulWidget {
  const ApplicantOrgPage({super.key});

  @override
  State<ApplicantOrgPage> createState() => _ApplicantOrgPageState();
}

class _ApplicantOrgPageState extends State<ApplicantOrgPage> {
  bool _isPressed1 = false;
  bool _isPressed2 = false;
  bool _isPressed3 = false;
  bool _isPressed4 = false;

  void _navigateToPage(Widget page, int buttonIndex) async {
    setState(() {
      switch (buttonIndex) {
        case 1:
          _isPressed1 = true;
          break;
        case 2:
          _isPressed2 = true;
          break;
        case 3:
          _isPressed3 = true;
          break;
        case 4:
          _isPressed4 = true;
          break;
      }
    });

    await Future.delayed(Duration(milliseconds: 50));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ).then((_) {
      setState(() {
        switch (buttonIndex) {
          case 1:
            _isPressed1 = false;
            break;
          case 2:
            _isPressed2 = false;
            break;
          case 3:
            _isPressed3 = false;
            break;
          case 4:
            _isPressed4 = false;
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage("assets/images/whitebg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PatrickHandSC(
                  text: "UP Sandiwa Samahang Bulakenyo", fontSize: 32),
              const SizedBox(height: 20),
              PatrickHand(
                  text: "Tungo sa Makabuluhang Pagkilos at Paglilingkod",
                  fontSize: 20),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedButton(
                  order: 1,
                  isPressed: _isPressed1,
                  icon: Icons.history_edu,
                  text: "Kasaysayan, Simbulo, at Preambulo",
                  onTap: () => _navigateToPage(Konstitusyon(), 1),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedButton(
                  order: 2,
                  isPressed: _isPressed2,
                  icon: Icons.library_books,
                  text: "Konstitusyon",
                  onTap: () => _navigateToPage(Konstitusyon(), 2),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedButton(
                  order: 1,
                  isPressed: _isPressed3,
                  icon: Icons.list_alt,
                  text: "Mga Lupon at Katungkulan",
                  onTap: () => _navigateToPage(Konstitusyon(), 3),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedButton(
                  order: 2,
                  isPressed: _isPressed4,
                  icon: Icons.people,
                  text: "Talaan ng Batches at Residente",
                  onTap: () => _navigateToPage(Konstitusyon(), 4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
