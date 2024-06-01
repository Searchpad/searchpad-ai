// ignore_for_file: must_be_immutable

import "package:booking_system_flutter/utils/constant.dart";
import "package:booking_system_flutter/utils/string_extensions.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:nb_utils/nb_utils.dart';
import 'package:booking_system_flutter/main.dart';

class CustomButton extends StatefulWidget {
  String? title;
  double? scale;
  String? icon;
  Color? color;
  int? index;
  CustomButton(this.title, this.scale,
      {this.icon = "", this.color = Colors.white, this.index = 1});
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext contes) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.scale!,
      height: 50,
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(30),
        color: widget.color != Colors.white
            ? widget.color
            : appStore.isDarkMode
                ? const Color(0xFF1F222A)
                : cardLightColor,
        boxShadow: [
          BoxShadow(color: shadowColorGlobal, offset: Offset(1, 0)),
          BoxShadow(color: shadowColorGlobal, offset: Offset(0, 1)),
          BoxShadow(color: shadowColorGlobal, offset: Offset(-1, 0)),
          BoxShadow(color: shadowColorGlobal, offset: Offset(0, -1)),
        ],
      ),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon != ""
              ? widget.icon!.iconImage(
                  size: SETTING_ICON_SIZE,
                  fit: BoxFit.contain,
                  index: widget.index)
              : SizedBox(width: 0),
          widget.icon != ""
              ? SizedBox(
                  width: 10,
                )
              : SizedBox(width: 0),
          widget.title != "" ? Text(
            widget.title!,
            style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.workSans().fontFamily,
                fontWeight: FontWeight.w500,
                color: widget.index == 3
                    ? Colors.white
                    : appStore.isDarkMode
                        ? Colors.white
                        : const Color(0xFF1F222A)),
          ): SizedBox(width: 0,)
        ],
      )),
    );
  }
}
