import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/model/user/user_model.dart';

///* Global Loading, usefull to show loading
final isLoading = StateProvider.autoDispose<bool>((ref) => false);

///* For hold value textfield search user by email
final searchQueryEmail = StateProvider.autoDispose<String>((ref) => '');

///* Hold Pairing Object, then we can use this in anywhere screen
final pairingGlobal = StateProvider<UserModel?>((ref) => null);

///* This class use for hold message then send it to firebase notification
///* The scenario is, when user send message example "halo say"
///* Then user send message again "lagi dimana ?"
///* Then FCM will show 2 message ['halo say','lagi dimana?'] in notification
class TemporaryListMessages extends StateNotifier<List<String>> {
  TemporaryListMessages() : super([]);

  void add(String message) {
    state = [...state, message];
  }

  void clear() {
    state = [];
  }
}

final tempListMessages =
    StateNotifierProvider<TemporaryListMessages, List<String>>((ref) => TemporaryListMessages());
