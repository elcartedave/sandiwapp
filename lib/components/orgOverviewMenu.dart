import 'package:flutter/material.dart';

class OrgOverviewMenu extends StatefulWidget {
  final String text;
  final Function() onTap;
  const OrgOverviewMenu({required this.text, required this.onTap, super.key});

  @override
  State<OrgOverviewMenu> createState() => _OrgOverviewMenuState();
}

class _OrgOverviewMenuState extends State<OrgOverviewMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
            child: Text(
          widget.text,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
