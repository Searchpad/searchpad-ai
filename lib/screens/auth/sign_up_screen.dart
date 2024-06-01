import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/custom_button.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/selected_item_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/email_verification.dart';
import 'package:booking_system_flutter/screens/auth/referral_screen.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;
  final String? uid;

  SignUpScreen(
      {Key? key,
      this.phoneNumber,
      this.isOTPLogin = false,
      this.countryCode,
      this.uid})
      : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();
  String email = "";
  String baseReferral = "";
  int baseConfirm = 0;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController referralCode = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode referralFocus = FocusNode();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference thread;

  bool isAcceptedTc = false;

  @override
  void initState() {
    super.initState();
    thread = firestore.collection('Referral6');
    init();
  }

  void init() async {
    if (widget.phoneNumber != null) {
      selectedCountry = Country.parse(
          widget.countryCode.validate(value: selectedCountry.countryCode));

      mobileCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      passwordCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      userNameCont.text =
          widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    }
  }

  String generateRandomCode(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Logic
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  Future<void> registerWithOTP() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      UserData userResponse = UserData()
        ..username = widget.phoneNumber.validate().trim()
        ..loginType = LOGIN_TYPE_OTP
        ..contactNumber = buildMobileNumber()
        ..email = emailCont.text.trim()
        ..firstName = fNameCont.text.trim()
        ..lastName = lNameCont.text.trim()
        ..playerId = getStringAsync(PLAYERID)
        ..userType = USER_TYPE_USER
        ..uid = widget.uid.validate()
        ..password = widget.phoneNumber.validate().trim();

      await createUsers(tempRegisterData: userResponse);
    }
  }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryFilter: ["BH", "KW", "OM", "QA", "SA", "AE"],
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: language.search,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  void registerUser() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      if (isAcceptedTc) {
        appStore.setLoading(true);

        /// Create a temporary request to send
        UserData tempRegisterData = UserData()
          ..contactNumber = "123456789"
          ..firstName = emailCont.text.trim()
          ..lastName = "👋"
          ..userType = USER_TYPE_USER
          ..username = emailCont.text.trim()
          ..email = emailCont.text.trim()
          ..password = passwordCont.text.trim();

        createUsers(tempRegisterData: tempRegisterData);
      }
    }
  }

  Future<void> createUsers({required UserData tempRegisterData}) async {
    await createUser(tempRegisterData.toJson()).then((registerResponse) async {
      if (referralCode.text.trim() != "") {
        print("ppppppppppppppppp");
        bool updatedConfirm = false;
        QuerySnapshot snapshot = await thread.get(); 
          for (QueryDocumentSnapshot doc in snapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            print(data);
            if (data["referral"] == referralCode.text.trim() &&
                !updatedConfirm) {
              print("11111111----------------------------");
              email = data["creator"];
              baseReferral = data['referral'];
              baseConfirm = data['confirm'] + 1;
              print("-----------------${data["creator"]}");
              doc.reference.delete();
              updatedConfirm = true;
              thread.add({
                "creator": email,
                "referral": baseReferral,
                "confirm": baseConfirm
              });
              String referral = generateRandomCode(6);
              thread.add({
                "creator": emailCont.text.trim(),
                "referral": referral,
                "confirm": 1
              });
              ReferralScreen(email: emailCont.text.trim()).launch(context);
              break;
            }
            print(data);
          }
          updatedConfirm = false;
        print("oooooooooooooooooooooooo");
      } else {
        String referral = generateRandomCode(6);
        thread.add({
          "creator": emailCont.text.trim(),
          "referral": referral,
          "confirm": 1
        });
        ReferralScreen(email: emailCont.text.trim()).launch(context);
      }
      // registerResponse.userData!.password = passwordCont.text.trim();
      // var request;

      /// After successful entry in the mysql database it will login into firebase.

      // if (widget.isOTPLogin) {
      //   request = {
      //     'username': widget.phoneNumber.validate(),
      //     'password': widget.phoneNumber.validate(),
      //     'player_id': getStringAsync(PLAYERID, defaultValue: ""),
      //     'login_type': LOGIN_TYPE_OTP,
      //     "uid": widget.uid.validate(),
      //   };
      // } else {
      //   request = {
      //     "email": registerResponse.userData!.email.validate(),
      //     'password': registerResponse.userData!.password.validate(),
      //     'player_id': getStringAsync(PLAYERID),
      //   };
      // }

      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => EmailVerification(
      //       response: registerResponse['data'],
      //     ),
      //   ),
      // );

      /// Calling Login API
      /// Prem
      // await loginCurrentUsers(context,
      //         req: request, isSocialLogin: widget.isOTPLogin)
      //     .then((res) async {
      //   saveDataToPreference(context,
      //       userData: res.userData!,
      //       isSocialLogin: widget.isOTPLogin, onRedirectionClick: () {
      //     DashboardScreen().launch(context, isNewTask: true);
      //   });
      // }).catchError((e) {
      //   toast(language.lblLoginAgain);
      //   SignInScreen().launch(context, isNewTask: true);
      // });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  //endregion

  //region Widget
  // Widget _buildTopWidget() {
  //   return Column(
  //     children: [
  //       Container(
  //         height: 80,
  //         width: 80,
  //         padding: EdgeInsets.all(16),
  //         child: ic_profile2.iconImage(color: Colors.white),
  //         decoration:
  //             boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
  //       ),
  //       16.height,
  //       Text(language.lblHelloUser, style: boldTextStyle(size: 22)).center(),
  //       16.height,
  //       Text(language.lblSignUpSubTitle,
  //               style: secondaryTextStyle(size: 14),
  //               textAlign: TextAlign.center)
  //           .center()
  //           .paddingSymmetric(horizontal: 32),
  //     ],
  //   );
  // }

  // Widget _buildFormWidget() {
  //   return Column(
  //     children: [
  //       32.height,
  //       AppTextField(
  //         textFieldType: TextFieldType.NAME,
  //         controller: fNameCont,
  //         focus: fNameFocus,
  //         nextFocus: lNameFocus,
  //         errorThisFieldRequired: language.requiredText,
  //         decoration:
  //             inputDecoration(context, labelText: language.hintFirstNameTxt),
  //         suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
  //       ),
  //       16.height,
  //       AppTextField(
  //         textFieldType: TextFieldType.NAME,
  //         controller: lNameCont,
  //         focus: lNameFocus,
  //         nextFocus: userNameFocus,
  //         errorThisFieldRequired: language.requiredText,
  //         decoration:
  //             inputDecoration(context, labelText: language.hintLastNameTxt),
  //         suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
  //       ),
  //       // 16.height,
  //       // AppTextField(
  //       //   textFieldType: TextFieldType.USERNAME,
  //       //   controller: userNameCont,
  //       //   focus: userNameFocus,
  //       //   nextFocus: emailFocus,
  //       //   readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
  //       //   errorThisFieldRequired: language.requiredText,
  //       //   decoration:
  //       //       inputDecoration(context, labelText: language.hintUserNameTxt),
  //       //   suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
  //       // ),
  //       16.height,
  //       AppTextField(
  //         textFieldType: TextFieldType.EMAIL_ENHANCED,
  //         controller: emailCont,
  //         focus: emailFocus,
  //         errorThisFieldRequired: language.requiredText,
  //         nextFocus: mobileFocus,
  //         decoration:
  //             inputDecoration(context, labelText: language.hintEmailTxt),
  //         suffix: ic_message.iconImage(size: 10).paddingAll(14),
  //       ),
  //       16.height,
  //       AppTextField(
  //         textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
  //         controller: mobileCont,
  //         focus: mobileFocus,
  //         buildCounter: (_,
  //             {required int currentLength,
  //             required bool isFocused,
  //             required int? maxLength}) {
  //           return TextButton(
  //             child: Text(language.lblChangeCountry,
  //                 style: primaryTextStyle(size: 12)),
  //             onPressed: () {
  //               changeCountry();
  //             },
  //           );
  //         },
  //         errorThisFieldRequired: language.requiredText,
  //         nextFocus: passwordFocus,
  //         decoration: inputDecoration(context,
  //                 labelText: "${language.hintContactNumberTxt}")
  //             .copyWith(
  //           prefixText: '+${selectedCountry.phoneCode} ',
  //           hintText: '${language.lblExample}: ${selectedCountry.example}',
  //           hintStyle: secondaryTextStyle(),
  //         ),
  //         maxLength: 15,
  //         suffix: ic_calling.iconImage(size: 10).paddingAll(14),
  //       ),
  //       4.height,
  //       AppTextField(
  //         textFieldType: TextFieldType.PASSWORD,
  //         controller: passwordCont,
  //         focus: passwordFocus,
  //         readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
  //         suffixPasswordVisibleWidget:
  //             ic_show.iconImage(size: 10).paddingAll(14),
  //         suffixPasswordInvisibleWidget:
  //             ic_hide.iconImage(size: 10).paddingAll(14),
  //         errorThisFieldRequired: language.requiredText,
  //         decoration:
  //             inputDecoration(context, labelText: language.hintPasswordTxt),
  //         onFieldSubmitted: (s) {
  //           if (widget.isOTPLogin) {
  //             registerWithOTP();
  //           } else {
  //             registerUser();
  //           }
  //         },
  //       ),
  //       20.height,
  //       _buildTcAcceptWidget(),
  //       8.height,
  //       AppButton(
  //         text: language.signUp,
  //         color: primaryColor,
  //         textColor: Colors.white,
  //         width: context.width() - context.navigationBarHeight,
  //         onTap: () {
  //           if (widget.isOTPLogin) {
  //             registerWithOTP();
  //           } else {
  //             registerUser();
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildTcAcceptWidget() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
  //         isAcceptedTc = !isAcceptedTc;
  //         setState(() {});
  //       }),
  //       16.width,
  //       RichTextWidget(
  //         list: [
  //           TextSpan(
  //               text: '${language.lblAgree} ', style: secondaryTextStyle()),
  //           TextSpan(
  //             text: language.lblTermsOfService,
  //             style: boldTextStyle(color: primaryColor, size: 14),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 commonLaunchUrl(TERMS_CONDITION_URL,
  //                     launchMode: LaunchMode.externalApplication);
  //               },
  //           ),
  //           TextSpan(text: ' & ', style: secondaryTextStyle()),
  //           TextSpan(
  //             text: language.privacyPolicy,
  //             style: boldTextStyle(color: primaryColor, size: 14),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 commonLaunchUrl(PRIVACY_POLICY_URL,
  //                     launchMode: LaunchMode.externalApplication);
  //               },
  //           ),
  //         ],
  //       ).flexible(flex: 2),
  //     ],
  //   ).paddingSymmetric(vertical: 16);
  // }

  // Widget _buildFooterWidget() {
  //   return Column(
  //     children: [
  //       16.height,
  //       RichTextWidget(
  //         list: [
  //           TextSpan(
  //               text: "${language.alreadyHaveAccountTxt} ? ",
  //               style: secondaryTextStyle()),
  //           TextSpan(
  //             text: language.signIn,
  //             style: boldTextStyle(color: primaryColor, size: 14),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 finish(context);
  //               },
  //           ),
  //         ],
  //       ),
  //       30.height,
  //     ],
  //   );
  // }

  Widget _buildTopWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Hello there👋", style: boldTextStyle(size: 28))
            .paddingSymmetric(horizontal: 10),
        16.height,
        Text(
          "Please enter your email & password to create an account.",
          style: primaryTextStyle(size: 14),
        ).paddingSymmetric(horizontal: 10),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        32.height,
        Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.EMAIL_ENHANCED,
                  controller: emailCont,
                  focus: emailFocus,
                  errorThisFieldRequired: language.requiredText,
                  nextFocus: mobileFocus,
                  decoration: inputDecoration(context,
                      labelText: language.hintEmailTxt),
                  suffix: ic_message.iconImage(size: 10).paddingAll(14),
                ),
                25.height,
                AppTextField(
                  textFieldType: TextFieldType.PASSWORD,
                  controller: passwordCont,
                  focus: passwordFocus,
                  readOnly:
                      widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
                  suffixPasswordVisibleWidget: ic_show
                      .iconImage(size: 10, color: thirdColor)
                      .paddingAll(14),
                  suffixPasswordInvisibleWidget: ic_hide
                      .iconImage(size: 10, color: thirdColor)
                      .paddingAll(14),
                  errorThisFieldRequired: language.requiredText,
                  decoration: inputDecoration(context,
                      labelText: language.hintPasswordTxt),
                ),
                25.height,
              ],
            )),
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: referralCode,
          focus: referralFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          suffix: ic_invite.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context,
              labelText: "Invite Code(optional)",
              hintText: "Enter Your Invite Code"),
        ),
        4.height,
        _buildTcAcceptWidget(),
        Divider(color: context.dividerColor, thickness: 2),
        16.height,
        _buildFooterWidget(),
        InkWell(
          onTap: () {
            registerUser();
          },
          child: CustomButton(
            'Sign up',
            0.9,
            color: thirdColor,
            index: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        4.width,
        RichTextWidget(
          list: [
            TextSpan(
                text: '${language.lblAgree} ',
                style: primaryTextStyle(size: 12)),
            TextSpan(
              text: language.lblTermsOfService,
              style: boldTextStyle(color: thirdColor, size: 12),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(TERMS_CONDITION_URL,
                      launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.privacyPolicy,
              style: boldTextStyle(color: thirdColor, size: 12),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(PRIVACY_POLICY_URL,
                      launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        RichTextWidget(
          list: [
            TextSpan(
                text: "${language.alreadyHaveAccountTxt}  ",
                style: primaryTextStyle(size: 14)),
            TextSpan(
              text: language.signIn,
              style: boldTextStyle(color: thirdColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        70.height,
        Divider(color: context.dividerColor, thickness: 2),
        8.height,
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: BackWidget(iconColor: context.iconColor),
        title: Padding(
          padding: EdgeInsets.all(0.0),
          child: new LinearPercentIndicator(
            width: 200.0,
            lineHeight: 14.0,
            percent: 0.4,
            barRadius: Radius.circular(8),
            backgroundColor: Color(0xFF35383F),
            progressColor: thirdColor,
          ),
        ),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTopWidget(),
                  _buildFormWidget(),
                  8.height,
                ],
              ),
            ),
            Observer(
                builder: (_) =>
                    LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
