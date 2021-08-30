import 'package:flutter/cupertino.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

class Constant {
  String get baseApi => 'http://192.168.10.2/API/api.basabasi';

  String get onboardingImage1 => '${appConfig.urlImageAsset}/onboarding1.png';
  String get onboardingImage2 => '${appConfig.urlImageAsset}/onboarding2.png';
  String get onboardingImage3 => '${appConfig.urlImageAsset}/onboarding3.png';

  TextStyle get fontComfortaa => GoogleFonts.comfortaa();
  TextStyle get fontMontserrat => GoogleFonts.montserratAlternates();

  /// Shared Preferences keys
  String get onboardingKey => 'onboardingKey';

  ///* Path Firebase Child
  String get childUsers => 'users';
  String get childChatsMessage => 'chats_message';
  String get childChatsRecent => 'chats_recent';
}
