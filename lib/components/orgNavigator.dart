import 'package:flutter/material.dart';
import 'package:sandiwapp/components/styles.dart';

class OrgNavigator extends StatefulWidget {
  final Function() onTap;
  final String label;
  final String clicked;
  const OrgNavigator(
      {required this.label,
      required this.onTap,
      required this.clicked,
      super.key});

  @override
  State<OrgNavigator> createState() => _OrgNavigatorState();
}

class _OrgNavigatorState extends State<OrgNavigator> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: ShapeDecoration(
          color: widget.clicked == widget.label ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          widget.label,
          style: widget.clicked == widget.label ? whiteText : blackText,
        ),
      ),
    );
  }
}
