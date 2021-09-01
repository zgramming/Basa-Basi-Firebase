import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/network.dart';

import '../provider.dart';

class SelectedRecentChatProvider extends StateNotifier<SelectedRecentChatState> {
  static final provider =
      StateNotifierProvider.autoDispose<SelectedRecentChatProvider, SelectedRecentChatState>(
          (ref) => SelectedRecentChatProvider());

  SelectedRecentChatProvider() : super(const SelectedRecentChatState());

  bool isExistsSelectedRecentChat(ChatsRecentModel recent) {
    return state.isExistsSelectedRecentChat(recent);
  }

  void add(ChatsRecentModel chat) {
    state = state.add(chat);
    log('Items ${state.items}');
  }

  void reset() {
    state = state.resetRecentChat();
  }
}
