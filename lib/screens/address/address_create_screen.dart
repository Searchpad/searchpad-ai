import 'package:booking_system_flutter/screens/address/address_edit_screen.dart';
import 'package:booking_system_flutter/screens/products/ui_helper.dart';
import 'package:booking_system_flutter/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../component/back_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';

class AddressAddScreen extends StatefulWidget {
  const AddressAddScreen({
    super.key,
    this.callBack,
  });
  final Function()? callBack;
  @override
  _AddressAddScreenState createState() => _AddressAddScreenState();
}

class _AddressAddScreenState extends State<AddressAddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  double? _latitude = 0;
  double? _longitude = 0;
  bool isdDefault = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = position.latitude;
      _longitude = position.longitude;

      final List<Placemark> placemarks =
          await placemarkFromCoordinates(_latitude!, _longitude!);
      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        _addressController.text = placemark.street ?? '';
        _cityController.text = placemark.locality ?? '';

        setState(() {});
      } else {}
    } catch (e) {
      // Handle any errors that occur during location retrieval
      print('Error during location retrieval: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        backWidget: BackWidget(iconColor: white),
        color: context.primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: context.primaryColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light),
        titleWidget: Text(
          language.lblAddAddress,
          style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () async {
                    var status = await requestLocationPermission();

                    if (status == PermissionStatus.granted) {
                      _getCurrentLocation();
                    } else if (status == PermissionStatus.denied) {
                      await requestLocationPermission();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please allow GPS permission first");
                    }
                    await requestLocationPermission();
                  },
                  label: Text(language.lblUseCurrentLocation),
                  icon: Icon(Icons.gps_fixed_rounded),
                ),
              ),
              UIHelper.verticalSpaceMedium(),
              texField(_nameController, language.lblName, TextFieldType.NAME),
              UIHelper.verticalSpaceMedium(),
              texField(
                  _phoneController, language.lblPhone, TextFieldType.PHONE),
              UIHelper.verticalSpaceMedium(),
              texField(
                  _emailController, language.hintEmailTxt, TextFieldType.EMAIL),
              UIHelper.verticalSpaceMedium(),
              texField(
                  _addressController, language.hintAddress, TextFieldType.NAME),
              UIHelper.verticalSpaceMedium(),
              texField(_cityController, language.lblCity, TextFieldType.NAME),
              UIHelper.verticalSpaceMedium(),
              _buildCheckBox(),
              SizedBox(height: 50),
              AppButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    Map address = {
                      "name": _nameController.text,
                      "phone": _phoneController.text,
                      "email": _emailController.text,
                      "address": _addressController.text,
                      "city": _cityController.text,
                      "set_default": isdDefault ? 1 : 0,
                      "postal_code": "",
                      "latitude": _latitude,
                      "longitude": _longitude,
                    };
                    var resp = await createShippingAddress(address);
                    if (resp['message']['status'] == true) {
                      Fluttertoast.showToast(msg: resp['message']['message']);
                      await widget.callBack?.call();
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: resp['message']['message']);
                    }
                  }
                },
                color: context.primaryColor,
                child: Text(language.lblCreateAdress,
                    style: boldTextStyle(color: white)),
                width: context.width(),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: isdDefault,
            onChanged: (val) {
              isdDefault = val ?? false;
              setState(() {});
            }),
        Text(
          language.markDefaultAddress,
          style: primaryTextStyle(),
        )
      ],
    );
  }

  Widget texField(controller, label, textFieldType) {
    return AppTextField(
      textFieldType: textFieldType,
      controller: controller,
      errorThisFieldRequired: language.requiredText,
      decoration: inputDecoration(context, labelText: label),
    );
  }

//   Widget texField(controller, label) {
//     return

//     SizedBox(
//       height: 50,
//       child: TextFormField(
//         controller: controller,
//         style: TextStyle(color: appStore.isDarkMode ? whiteColor : black),
//         decoration: InputDecoration(
//           labelText: label,
//           enabledBorder: OutlineInputBorder(
//               borderSide:
//                   const BorderSide(color: Color.fromARGB(255, 215, 215, 215)),
//               borderRadius: BorderRadius.circular(10)),
//           errorBorder: OutlineInputBorder(
//               borderSide: const BorderSide(color: Colors.red),
//               borderRadius: BorderRadius.circular(10)),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: primaryColor, width: 1.5),
//               borderRadius: BorderRadius.circular(10)),
//           focusedErrorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: primaryColor, width: 1.5),
//               borderRadius: BorderRadius.circular(10)),
//         ),
//         validator: (value) {
//           if (value?.isEmpty ?? true) {
//             return '${language.lblPleaseEnter} $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }

// Future<PermissionStatus> requestLocationPermission() async {
//   return await Permission.location.request();
}
