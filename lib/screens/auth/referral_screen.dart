// ignore_for_file: must_be_immutable

import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/base_scaffold_body.dart';
import 'package:booking_system_flutter/component/custom_button.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/fragment/profile_fragment.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralScreen extends StatefulWidget {
  String? email;

  ReferralScreen({this.email});

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference thread;
  int count = 0;
  String referralCode = "";

  @override
  void initState() {
    super.initState();
    getFirebase();
  }

  Future<void> getFirebase() async {
    thread = firestore.collection('Referral6');
    print(widget.email);
    QuerySnapshot snapshot = await thread.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print(data);
      if (data['creator'] == widget.email) {
        print("-----------------------------11111111111111111");
        referralCode = data['referral'];
        setState(() {
          count = data['confirm'];
        });
        print(count);
        break;
      }
    }
  }

  Widget _buildTopWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Boost Your Earnings By Inviting Friends",
            style: boldTextStyle(size: 28),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 10),
          25.height,
          Text(
            "Share your unique referral link with friends and watch your rewards grow. For every new user who signs up to Searchpad using your link, you'll earn 1000 Search points.",
            style: secondaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 20),
          25.height,
          Text(
            "At the time of Token Generation Event (TGE), your Search points will be converted into \$SPAD.",
            style: secondaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 20),
          25.height,
          Text(
            "Join now and start earning together!",
            style: secondaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 20),
          20.height
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return AutofillGroup(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: referralCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Referral code copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            child: CustomButton(
              'Share Link',
              0.9,
              color: thirdColor,
              index: 3,
            ),
          ),
          25.height,
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  appStore.isDarkMode ? Color(0xFF1F222A) : Color(0xFF9E9E9E),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Your Search Points",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: GoogleFonts.workSans().fontFamily)),
                Container(
                  width: 70,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFF282B34)),
                  child: Center(
                      child: Text(
                    "${1000 * count}",
                    style: TextStyle(color: thirdColor, fontSize: 16),
                  )),
                )
              ],
            ),
          ),
          25.height,
          Container(
              height: 140,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:
                    appStore.isDarkMode ? Color(0xFF1F222A) : Color(0xFF9E9E9E),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Referrals",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: GoogleFonts.workSans().fontFamily),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Text(
                                "Show all",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily:
                                        GoogleFonts.workSans().fontFamily),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ))
                    ],
                  ),
                  10.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/avatar1.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/images/avatar2.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/images/avatar3.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/images/avatar4.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

//endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop()
            ? BackWidget(iconColor: context.iconColor)
            : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.qr_code,
                color: context.iconColor,
              ))
        ],
      ),
      body: Body(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTopWidget(),
              _buildFormWidget(),
              30.height,
            ],
          ),
        ),
      ),
    );
  }
}
