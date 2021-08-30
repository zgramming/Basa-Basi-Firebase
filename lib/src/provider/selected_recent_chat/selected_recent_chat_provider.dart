import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:basa_basi/src/network/network.dart';

class SelectedRecentChatProvider extends StateNotifier<List<ChatsRecentModel>> {
  SelectedRecentChatProvider() : super([]);

  static final provider =
      StateNotifierProvider.autoDispose<SelectedRecentChatProvider, List<ChatsRecentModel>>(
          (ref) => SelectedRecentChatProvider());

  void add(ChatsRecentModel chat) {
    final isExists = state.firstWhereOrNull((element) => element.id == chat.id);
    state = isExists == null
        ? [...state, chat]
        : [...state.where((element) => element.id != chat.id).toList()];
  }

  bool isExists(ChatsRecentModel chat) {
    final result = state.firstWhereOrNull((element) => element.id == chat.id);
    if (result == null) {
      return false;
    }
    return true;
  }

  void reset() {
    state = [];
  }
}

final isExistsSelectedRecentChat =
    StateProvider.autoDispose.family<bool, ChatsRecentModel>((ref, chat) {
  final recentsChat = ref.watch(SelectedRecentChatProvider.provider);
  final isExists = recentsChat.firstWhereOrNull((element) => element.id == chat.id);
  if (isExists == null) return false;
  return true;
});
