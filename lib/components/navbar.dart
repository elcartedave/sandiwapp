import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// NavBar class, used for bottom Navigation Bar

// ignore: must_be_immutable
class Navbar extends StatefulWidget {
  // ginamit para ma-update 'yung current page na dapat makita
  List<String> labels;
  final Function callback;
  int currentIndex;
  Navbar(this.labels, this.callback, this.currentIndex, {super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      color: widget.currentIndex == 2
          ? Colors.white
          : Color.fromARGB(255, 49, 49, 49),
      onTap: (index) {
        setState(() {
          widget.currentIndex = index;
        });
        widget.callback(widget
            .currentIndex); // callback para mabalik 'yung index sa homepage
      },
      items: [
        Icon(
          widget.currentIndex == 0 ? Icons.dashboard : Icons.dashboard_outlined,
          color: widget.currentIndex == 2 ? Colors.black : Colors.white,
        ),
        Icon(
          widget.currentIndex == 1 ? Icons.home : Icons.home_outlined,
          color: widget.currentIndex == 2 ? Colors.black : Colors.white,
        ),
        Icon(
          widget.currentIndex == 2
              ? Icons.account_circle
              : Icons.account_circle_outlined,
          color: widget.currentIndex == 2 ? Colors.black : Colors.white,
        )
      ],
    );
  }
}
