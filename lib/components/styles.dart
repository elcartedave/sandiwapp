import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final whiteText = GoogleFonts.patrickHand(color: Colors.white, fontSize: 16);
final blackText = GoogleFonts.patrickHand(color: Colors.black, fontSize: 16);

ButtonStyle activeActiveTheme = OutlinedButton.styleFrom(
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: const BorderSide(color: Colors.black, width: 2));

ButtonStyle activeInactiveTheme = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20))),
    side: const BorderSide(color: Colors.black, width: 2));

ButtonStyle inactiveActiveTheme = OutlinedButton.styleFrom(
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: const BorderSide(color: Colors.black, width: 2));

ButtonStyle inactiveInactiveTheme = OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
    side: const BorderSide(color: Colors.black, width: 2));
