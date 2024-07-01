import 'package:flutter/material.dart';
import 'package:sandiwapp/components/texts.dart';

class LogoLoadingPage extends StatelessWidget {
  const LogoLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/sandiwa_logo.png',
                width: 350,
              ),
              PatrickHandSC(
                text: "Nagloload....",
                fontSize: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
