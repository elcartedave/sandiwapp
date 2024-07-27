import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class OrgOverviewMenu extends StatefulWidget {
  final String text;
  final IconData icon;
  final Function() onTap;

  const OrgOverviewMenu({
    required this.icon,
    required this.text,
    required this.onTap,
    super.key,
  });

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: _isPressed
              ? [
                  // Inner shadow for pressed effect
                  BoxShadow(
                    color: Colors.grey[400]!,
                    offset: Offset(3, 3),
                    blurRadius: 4,
                    inset: true,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 4,
                    inset: true,
                  ),
                ]
              : [
                  // Outer shadow for default state
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.grey[400]!,
                    offset: Offset(3, 3),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 40,
                color: _isPressed ? Colors.grey[700] : Colors.black,
              ),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  color: _isPressed ? Colors.grey[700] : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
