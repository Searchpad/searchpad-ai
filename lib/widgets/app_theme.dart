import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppTheme {
  CustomAppTheme._();
  static TextStyle commonText = TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontFamily: GoogleFonts.workSans().fontFamily,
      fontWeight: FontWeight.w700);
}

class TextTheme1 {
  TextTheme1._();
  static TextStyle commonText = TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontFamily: GoogleFonts.workSans().fontFamily,
      fontWeight: FontWeight.w700);
}
