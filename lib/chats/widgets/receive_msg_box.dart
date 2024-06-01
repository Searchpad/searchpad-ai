// import 'dart:math' as math;
import 'package:booking_system_flutter/main.dart';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'msg_arrow_painter.dart';

class ReceiveMsgBox extends StatelessWidget {
  final String message;
  final DateTime createDate;
  const ReceiveMsgBox(
      {Key? key, required this.message, required this.createDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 45,
          //   width: 45,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(50)),
          //       color: Color(0xFF35383F)),
          //   child: Center(
          //     child: Text(
          //       firstLetter,
          //       style: ThemeConfig.bodyText1.override(
          //         color: ColorConstants.titleSecundary,
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(width: 10),
          // Transform(
          //   alignment: Alignment.center,
          //   transform: Matrix4.rotationY(math.pi),
          //   child: CustomPaint(painter: MsgArrowPainter(appStore.isDarkMode ? Colors.black : Colors.white)),
          // ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: boxDecorationDefault(
                color: context.cardColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(color: shadowColorGlobal, offset: Offset(1, 0)),
                  BoxShadow(color: shadowColorGlobal, offset: Offset(0, 1)),
                  BoxShadow(color: shadowColorGlobal, offset: Offset(-1, 0)),
                ],
              ),
              child: Text(
                message,
                style: TextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black,
                    fontFamily: 'GoogleFonts.workSans().fontFamily',
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 0, top: 10, bottom: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                DateFormat('dd/MM').format(createDate) +
                    ' - ' +
                    DateFormat('HH:mm').format(createDate),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'GoogleFonts.workSans().fontFamily',
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 10),
              messageTextGroup,
              SizedBox(
                width: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
