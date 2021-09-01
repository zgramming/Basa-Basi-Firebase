import 'package:basa_basi/src/network/network.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class SelectedRecentChatState extends Equatable {
  final List<ChatsRecentModel> items;
  const SelectedRecentChatState({
    this.items = const [],
  });

  bool isExistsSelectedRecentChat(ChatsRecentModel recent) {
    final result = items.firstWhereOrNull((element) => element.id == recent.id);
    if (result == null) {
      return false;
    }
    return true;
  }

  SelectedRecentChatState resetRecentChat() => copyWith(items: []);
  SelectedRecentChatState add(ChatsRecentModel recent) {
    var tempList = <ChatsRecentModel>[];
    final result = items.firstWhereOrNull((element) => element.id == recent.id);
    if (result == null) {
      tempList = [...items, recent];
    } else {
      tempList = [...items.where((element) => element.id != recent.id).toList()];
    }
    return copyWith(items: tempList);
  }

  int get totalSelected => items.length;

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  SelectedRecentChatState copyWith({
    List<ChatsRecentModel>? items,
  }) {
    return SelectedRecentChatState(
      items: items ?? this.items,
    );
  }
}
