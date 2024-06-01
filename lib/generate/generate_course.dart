import 'package:booking_system_flutter/component/custom_button.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:booking_system_flutter/chats/chat_screen.dart';
import 'package:booking_system_flutter/widgets/app_theme.dart';
import 'package:booking_system_flutter/widgets/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class GenerateCourse extends StatefulWidget {
  const GenerateCourse({super.key});

  @override
  State<GenerateCourse> createState() => _GenerateCourseState();
}

class _GenerateCourseState extends State<GenerateCourse> {
  String pdfName = "";
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   appBar: AppBar(
        //     backgroundColor: const Color(0xFF181A20),
        //     surfaceTintColor: Colors.transparent,
        //     leading: IconButton(
        //       icon: const Icon(Icons.arrow_back_outlined),
        //       color: Colors.white,
        //       onPressed: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //               builder: (BuildContext context) => ChatScreen()),
        //         );
        //       },
        //     ),
        //     title: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Generate with Ai',
        //           style: CustomAppTheme.commonText,
        //         )
        //       ],
        //     ),
        //   ),

        AppScaffold(
      appBarTitle: language.generateAI,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  language.industry,
                   style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Topic",
                  style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Keywords",
                  style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Numbers of Lessons",
                  style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Numbers of Assignments",
                  style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Additional Materials",
                  style: boldTextStyle(
                        color: textPrimaryColorGlobal),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 194,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromRGBO(105, 73, 255, 0.08),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    pdfName == ""
                        ? InkWell(
                            onTap: () {
                              _onFileButtonPressed();
                            },
                            child: Image.asset('assets/images/upload.png'),
                          )
                        : Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  pdfName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily:
                                          GoogleFonts.workSans().fontFamily,
                                      color: Colors.white),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        pdfName = "";
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          ),
                    pdfName == ""
                        ? Text(
                            'Upload PDF',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'GoogleFonts.workSans().fontFamily',
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6949FF)),
                          )
                        : Center(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                child: CustomButton('Generate', 0.9, color: thirdColor,),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );

    //   body: Container(
    //     width: MediaQuery.of(context).size.width,
    //     color: Color(0xFF181A20),
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Industry",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Topic",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Keywords",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Numbers of Lessons",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Numbers of Assignments",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           CustomTextField(),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             child: Text(
    //               "Additional Materials",
    //               style: CustomAppTheme.commonText,
    //               textAlign: TextAlign.start,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             height: 194,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(12),
    //               color: Color.fromRGBO(105, 73, 255, 0.08),
    //             ),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //                 pdfName == ""
    //                     ? InkWell(
    //                         onTap: () {
    //                           _onFileButtonPressed();
    //                         },
    //                         child: Image.asset('assets/images/upload.png'),
    //                       )
    //                     : Center(
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             Text(
    //                               pdfName,
    //                               style: TextStyle(
    //                                   fontSize: 20,
    //                                   fontFamily:
    //                                       'GoogleFonts.workSans().fontFamily',
    //                                   color: Colors.white),
    //                             ),
    //                             IconButton(
    //                                 onPressed: () {
    //                                   setState(() {
    //                                     pdfName = "";
    //                                   });
    //                                 },
    //                                 icon: Icon(
    //                                   Icons.cancel_outlined,
    //                                   color: Colors.white,
    //                                 ))
    //                           ],
    //                         ),
    //                       ),
    //                 pdfName == ""
    //                     ? Text(
    //                         'Upload PDF',
    //                         style: TextStyle(
    //                             fontSize: 20,
    //                             fontFamily: 'GoogleFonts.workSans().fontFamily',
    //                             fontWeight: FontWeight.w600,
    //                             color: Color(0xFF6949FF)),
    //                       )
    //                     : Center(),
    //                 SizedBox(
    //                   height: 20,
    //                 )
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 40,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),

    //   bottomNavigationBar: Container(
    //       width: MediaQuery.of(context).size.width,
    //       height: 80,
    //       decoration: BoxDecoration(color: Color(0xFF181A20)),
    //       child: Center(
    //         child: InkWell(
    //           onTap: () {
    //             Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => ChatScreen()));
    //           },
    //           child: Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             height: 58,
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(30),
    //                 color: Color(0xFF543ACC)),
    //             child: Center(
    //                 child: Text(
    //               'Generate',
    //               style: TextStyle(
    //                   fontSize: 16,
    //                   fontFamily: 'GoogleFonts.workSans().fontFamily',
    //                   fontWeight: FontWeight.w700,
    //                   color: Colors.white),
    //             )),
    //           ),
    //         ),
    //       )),
    // );
  }

  void _onFileButtonPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      print(result.files.single.path!);
      List<String> getPdfName = result.files.single.path!.split("/");
      setState(() {
        pdfName = getPdfName[getPdfName.length - 1];
        print("111111111111-----------${pdfName}");
      });
      String downloadUrl = '';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(file.path);
      UploadTask uploadTask = storageReference.putFile(File(file.path));

      TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        downloadUrl = await storageReference.getDownloadURL();
      }
    }
  }
}
