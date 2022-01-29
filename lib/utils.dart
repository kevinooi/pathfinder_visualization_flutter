import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static const int maxValue = 1000000; // infinity
  static const Color primaryColor = Color(0xffB993D6);
  static const Color startColor = Color(0xff0FDC82);
  static const Color endColor = Color(0xffF84145);
  static Color visitedColor = Colors.cyan[400]!;
  static Color shortColor = Colors.amber[400]!;
  static Color wallColor = Colors.black;

  static TextStyle bodyStyle = GoogleFonts.openSans().copyWith(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );
}
