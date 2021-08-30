import 'package:basa_basi/src/network/network.dart';
import 'package:basa_basi/src/provider/provider.dart';
import 'package:basa_basi/src/provider/user/user_provider.dart';
import 'package:basa_basi/src/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionProvider extends StateNotifier<SessionModel> {
  SessionProvider() : super(const SessionModel());

  static final provider =
      StateNotifierProvider<SessionProvider, SessionModel>((ref) => SessionProvider());
  Future<void> setOnboardingSession({required bool value}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(Constant().onboardingKey, value);
    state = state.copyWith(isAlreadyOnboarding: value);
  }

  Future<void> getOnboardingSession() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = pref.getBool(Constant().onboardingKey) ?? false;
    state = state.copyWith(isAlreadyOnboarding: result);
  }
}

final initializeApplication = FutureProvider<void>((ref) async {
  final _sessionProvider = ref.read(SessionProvider.provider.notifier);
  final _userProvider = ref.read(UserProvider.provider.notifier);
  await Future.wait([
    _userProvider.isAlreadySignIn(),
    _sessionProvider.getOnboardingSession(),
  ]);
});
