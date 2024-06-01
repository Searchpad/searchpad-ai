import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Munasbat';
const APP_NAME_TAG_LINE = 'On-Demand Home Services App';
var defaultPrimaryColor = Color(0xFF05E6F2);

const DOMAIN_URL = 'https://admin.munasbat.app';
// const DOMAIN_URL = 'https://munasbat.thtbh.com';
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const PROVIDER_PACKAGE_NAME = '';
const IOS_LINK_FOR_PARTNER = "";

const IOS_LINK_FOR_USER = '';

const DASHBOARD_AUTO_SLIDER_SECOND = 5;

const TERMS_CONDITION_URL = 'https://munasbat.app/?page_id=3037';
const PRIVACY_POLICY_URL = 'https://munasbat.app/?page_id=3039';
const INQUIRY_SUPPORT_EMAIL = 'https://munasbat.app/?page_id=710';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '';

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'BH';
const STRIPE_CURRENCY_CODE = 'BH';
DateTime todayDate = DateTime(2022, 8, 24);

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

Country defaultCountry() {
  return Country(
    phoneCode: '973',
    countryCode: 'BH',
    e164Sc: 973,
    geographic: true,
    level: 1,
    name: 'Bahrain',
    example: '97312345678',
    displayName: 'Bahrain (BH) [+973]',
    displayNameNoCountryCode: 'Bahrain (BH)',
    e164Key: '973-BH-0',
    fullExampleWithPlusSign: '+97312345678',
  );
}
