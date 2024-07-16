import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedButton extends StatelessWidget {
  final bool isPressed;
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final int order;

  const AnimatedButton({
    Key? key,
    required this.isPressed,
    required this.order,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          order == 1
              ? Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    transform: Matrix4.translationValues(
                        isPressed ? 4 : 0, isPressed ? 4 : 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 0,
                          offset: isPressed
                              ? Offset(0, 0)
                              : Offset(4, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Icon(icon, size: 75),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playball(fontSize: 22),
                  ),
                ),
          const SizedBox(width: 5),
          order == 1
              ? Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playball(fontSize: 22),
                  ),
                )
              : Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    transform: Matrix4.translationValues(
                        isPressed ? 4 : 0, isPressed ? 4 : 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 0,
                          offset: isPressed
                              ? Offset(0, 0)
                              : Offset(4, 4), // Shadow position
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Icon(icon, size: 75),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
