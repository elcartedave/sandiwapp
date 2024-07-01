import 'package:flutter/material.dart';
import 'package:sandiwapp/components/styles.dart';

class BlackButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const BlackButton({required this.text, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          text,
          style: whiteText,
        )),
      ),
    );
  }
}

class WhiteButton extends StatefulWidget {
  final Function()? onTap;
  final bool? acknowledged;
  final String text;
  const WhiteButton(
      {this.acknowledged, required this.text, this.onTap, super.key});

  @override
  State<WhiteButton> createState() => _WhiteButtonState();
}

class _WhiteButtonState extends State<WhiteButton> {
  late bool isClicked;
  void handleTap() {
    setState(() {
      isClicked = !isClicked;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    isClicked = widget.acknowledged ?? false;

    return GestureDetector(
      onTap: handleTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            color: widget.text != "Acknowledge"
                ? Colors.white
                : isClicked
                    ? Colors.black
                    : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          widget.text != "Acknowledge"
              ? widget.text
              : isClicked
                  ? "Acknowledged"
                  : widget.text,
          style: widget.text != "Acknowledge"
              ? blackText
              : isClicked
                  ? whiteText
                  : blackText,
        )),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyTextButton({required this.text, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: blackText,
      ),
    );
  }
}

class WhiteButtonWithIcon extends StatefulWidget {
  final Function()? onTap;
  final IconData iconData;
  final String text;
  const WhiteButtonWithIcon(
      {required this.iconData, required this.text, this.onTap, super.key});

  @override
  State<WhiteButtonWithIcon> createState() => _WhiteButtonWithIconState();
}

class _WhiteButtonWithIconState extends State<WhiteButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.iconData),
            const SizedBox(width: 10),
            Text(
              widget.text,
              style: blackText,
            ),
          ],
        )),
      ),
    );
  }
}
