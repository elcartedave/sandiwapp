import 'package:flutter/material.dart';
import 'package:sandiwapp/components/texts.dart';

class Execs extends StatefulWidget {
  const Execs({super.key});

  @override
  State<Execs> createState() => _ExecsState();
}

class _ExecsState extends State<Execs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PatrickHandSC(text: "Lupong Tagapagpaganap", fontSize: 24),
      ),
      body: SingleChildScrollView(
        child: Image.asset(
          "assets/images/execs.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
