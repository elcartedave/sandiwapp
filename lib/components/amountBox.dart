import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountBox extends StatelessWidget {
  final Function() onTap;
  final String amount;
  const AmountBox({required this.amount, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.black),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'ANG IYONG BALANSE:',
              style:
                  GoogleFonts.patrickHandSc(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            Text(
              "PHP ${amount}",
              style: GoogleFonts.patrickHand(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
