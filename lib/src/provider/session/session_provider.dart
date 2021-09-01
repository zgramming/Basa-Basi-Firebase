import 'dart:convert';

import 'package:basa_basi/src/network/model/user/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import '../provider.dart';
import '../user/user_provider.dart';
import './session_state.dart';

class SessionProvider extends StateNotifier<SessionState> {
  static final provider = StateNotifierProvider<SessionProvider, SessionState>((ref) {
    return SessionProvider();
  });

  SessionProvider() : super(const SessionState());

  final _userProvider = UserProvider();

  Future<void> setLoginSession({required UserModel? value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Constant().userKey, json.encode(value));
    state = state.setLoginSession(value: value);
  }

  Future<UserModel?> getLoginSession() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = pref.getString(Constant().userKey);
    UserModel? user;
    if (result != null) {
      final decode = json.decode(result);
      user = decode as UserModel;
    }
    state = state.getLoginSession(value: user);

    return user;
  }

  Future<void> setOnboardingSession({required bool value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(Constant().onboardingKey, value);
    state = state.setOnboardingSession(value: value);
  }

  Future<bool> getOnboardingSession() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = pref.getBool(Constant().onboardingKey) ?? false;
    state = state.getOnboardingSession(value: result);
    return result;
  }
}

class SplashScreenSessionModel {
  final UserModel? user;
  final bool alreadyOnboarding;
  SplashScreenSessionModel({
    required this.user,
    required this.alreadyOnboarding,
  });
}

final initializeApplication = FutureProvider<SplashScreenSessionModel>((ref) async {
  final _sessionProvider = ref.watch(SessionProvider.provider.notifier);
  final _userProvider = ref.watch(UserProvider.provider.notifier);

  final checkUser = await _userProvider.isAlreadySignIn();
  final checkOnboarding = await _sessionProvider.getOnboardingSession();

  return SplashScreenSessionModel(user: checkUser, alreadyOnboarding: checkOnboarding);
});
