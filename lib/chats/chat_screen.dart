import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_system_flutter/widgets/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booking_system_flutter/chats/widgets/send_msg_box.dart';
import 'package:booking_system_flutter/chats/widgets/receive_msg_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference thread;
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    thread = firestore.collection('Thread');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.threadAI,
      child: Container(
          child: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: thread.orderBy('date').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center();
                  default:
                    var documents = snapshot.data?.docs.reversed.toList() ??
                        <QueryDocumentSnapshot>[];
                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (documents[index]['sender'] == "me") {
                            return SendMsgBox(
                                message: documents[index]['message'],
                                createDate:
                                    (documents[index]['date']).toDate());
                          } else {
                            if (documents[index]['sender'] == 'ai') {
                              return ReceiveMsgBox(
                                  message: documents[index]['message'],
                                  createDate:
                                      (documents[index]['date']).toDate());
                            }
                          }
                          return Center();
                        });
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 56,
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: appStore.isDarkMode ? Color(0xFF1F222A) : Color(0xFF9E9E9E),
                      ),
                      child: Center(
                        child: TextField(
                          onSubmitted: _isComposing ? _handleSubmitted : null,
                          style: TextStyle(
                              fontSize: 16,
                              color: appStore.isDarkMode ? Color(0xFF9E9E9E) : Color(0xFF1F222A),
                              fontFamily: GoogleFonts.workSans().fontFamily),
                          controller: controller,
                          decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {},
                                child: Image.asset('assets/images/suffix.png', color: appStore.isDarkMode ? Color(0xFF9E9E9E) : Color(0xFF1F222A),),
                              ),
                              hintText: 'Message...',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: GoogleFonts.workSans().fontFamily,
                                  color: appStore.isDarkMode ? Color(0xFF9E9E9E) : Color(0xFF1F222A),
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              fillColor: appStore.isDarkMode ? Color(0xFF9E9E9E) : Color(0xFF1F222A)),
                          onChanged: (value) {
                            setState(() {
                              _isComposing = value.isNotEmpty;
                            });
                          },
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Color(0xFF9747FF),
                    ),
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                  ))
                ],
              )),
        ],
      )),);

    // Scaffold(
    //   backgroundColor: const Color(0xFF181A20),
    //   appBar: AppBar(
    //     backgroundColor: const Color(0xFF181A20),
    //     surfaceTintColor: Colors.transparent,
    //     leading: IconButton(
    //       icon: const Icon(Icons.arrow_back_outlined),
    //       color: Colors.white,
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Threads AI,',
    //           style: CustomAppTheme.commonText,
    //         )
    //       ],
    //     ),
    //   ),
    //   body: Container(
    //       child: Column(
    //     children: [
    //       Flexible(
    //         child: StreamBuilder<QuerySnapshot>(
    //           stream: thread.orderBy('date').snapshots(),
    //           builder: (context, snapshot) {
    //             switch (snapshot.connectionState) {
    //               case ConnectionState.none:
    //                 return const Center();
    //               default:
    //                 var documents = snapshot.data?.docs.reversed.toList() ??
    //                     <QueryDocumentSnapshot>[];
    //                 return ListView.builder(
    //                     itemCount: documents.length,
    //                     reverse: true,
    //                     itemBuilder: (context, index) {
    //                       if (documents[index]['sender'] == "me") {
    //                         return SendMsgBox(
    //                             message: documents[index]['message'],
    //                             createDate:
    //                                 (documents[index]['date']).toDate());
    //                       } else {
    //                         if (documents[index]['sender'] == 'ai') {
    //                           return ReceiveMsgBox(
    //                               message: documents[index]['message'],
    //                               createDate:
    //                                   (documents[index]['date']).toDate());
    //                         }
    //                       }
    //                       return Center();
    //                     });
    //             }
    //           },
    //         ),
    //       ),
    //       Container(
    //         decoration: BoxDecoration(
    //             border: Border(
    //                 bottom: BorderSide(
    //           width: 1.0,
    //         ))),
    //       ),
    //       Container(
    //           width: MediaQuery.of(context).size.width,
    //           height: 80,
    //           decoration: BoxDecoration(color: Color(0xFF181A20)),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                   height: 56,
    //                   width: MediaQuery.of(context).size.width * 0.7,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(12),
    //                     color: const Color(0xFF1F222A),
    //                   ),
    //                   child: Center(
    //                     child: TextField(
    //                       onSubmitted: _isComposing ? _handleSubmitted : null,
    //                       style: TextStyle(
    //                           fontSize: 16,
    //                           color: Colors.white,
    //                           fontFamily: 'GoogleFonts.workSans().fontFamily'),
    //                       controller: controller,
    //                       decoration: InputDecoration(
    //                           suffixIcon: InkWell(
    //                             onTap: () {},
    //                             child: Image.asset('assets/images/suffix.png'),
    //                           ),
    //                           hintText: 'Message...',
    //                           hintStyle: TextStyle(
    //                               fontSize: 14,
    //                               fontFamily: GoogleFonts.workSans().fontFamily,
    //                               color: Color(0xFF9E9E9E),
    //                               fontWeight: FontWeight.w400),
    //                           border: OutlineInputBorder(
    //                               borderSide: BorderSide.none),
    //                           fillColor: Colors.white),
    //                       onChanged: (value) {
    //                         setState(() {
    //                           _isComposing = value.isNotEmpty;
    //                         });
    //                       },
    //                     ),
    //                   )),
    //               SizedBox(
    //                 width: 20,
    //               ),
    //               InkWell(
    //                   child: Container(
    //                 width: 56,
    //                 height: 56,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(28),
    //                   color: Color(0xFF9747FF),
    //                 ),
    //                 child: Icon(
    //                   Icons.mic,
    //                   color: Colors.white,
    //                 ),
    //               ))
    //             ],
    //           )),
    //     ],
    //   )),
    // );
  }

  void _handleSubmitted(String text) async {
    setState(() {
      _isComposing = false;
    });
    thread.add({
      "sender": "me",
      "message": text,
      'date': DateTime.now(),
    });
    String result = "";
    controller.clear();
    if (text != "") {
      result = await sendMessage(text);
    }
    if (result != "error") {
      thread.add({
        "sender": "ai",
        "message": result,
        'date': DateTime.now(),
      });
    }
  }

  Future<String> sendMessage(String message) async {
    var url = Uri.parse('http://35.78.80.226:3000/chat');
    var data = {"prompt": message};

    final requestBody = jsonEncode(data);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody);
    if (response.statusCode == 200) {
      return json.decode(response.body)["result"];
    } else {
      return "error";
    }
  }
}
