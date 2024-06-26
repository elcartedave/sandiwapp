import 'package:flutter/material.dart';

class OrgOverviewMenu extends StatefulWidget {
  final String text;
  final IconData icon;
  final Function() onTap;
  const OrgOverviewMenu(
      {required this.icon, required this.text, required this.onTap, super.key});

  @override
  State<OrgOverviewMenu> createState() => _OrgOverviewMenuState();
}

class _OrgOverviewMenuState extends State<OrgOverviewMenu> {
  bool _isPressed = false;

  void _handleTap() async {
    setState(() {
      _isPressed = true;
    });
    await Future.delayed(Duration(milliseconds: 100));
    widget.onTap();
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: _isPressed ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  size: 40, color: _isPressed ? Colors.white : Colors.black),
              Text(
                widget.text,
                style: TextStyle(
                    fontSize: 16,
                    color: _isPressed ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
