// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, annotate_overrides, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:booking_system_flutter/main.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  @override
  CustomTextField({this.controller});

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        height: 60,
        width: width * 0.9,
        decoration: boxDecorationDefault(
          color: appStore.isDarkMode ? const Color(0xFF1F222A) : cardLightColor,
          boxShadow: [
            BoxShadow(color: shadowColorGlobal, offset: Offset(1, 0)),
            BoxShadow(color: shadowColorGlobal, offset: Offset(0, 1)),
            BoxShadow(color: shadowColorGlobal, offset: Offset(-1, 0)),
            BoxShadow(color: shadowColorGlobal, offset: Offset(0, -1)),
          ],
        ),
        child: Center(
          child: TextField(
            style: TextStyle(
                fontSize: 16,
                color: appStore.isDarkMode ? Colors.white : Colors.black,
                fontFamily: GoogleFonts.workSans().fontFamily),
            controller: controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                fillColor: Colors.white),
            onChanged: (value) {
              controller!.text = value;
            },
          ),
        ));
  }
}
