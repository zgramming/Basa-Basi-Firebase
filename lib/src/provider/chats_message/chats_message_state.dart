import 'dart:collection';

import 'package:basa_basi/src/utils/shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../network/network.dart';

class ChatsMessageState extends Equatable {
  const ChatsMessageState({
    this.items = const [],
  });
  final List<ChatsMessageModel> items;

  ChatsMessageState addAll(List<ChatsMessageModel> values) => copyWith(items: values);

  SplayTreeMap<DateTime, List<ChatsMessageModel>> chatsByChannel({
    required String senderId,
    required String pairingId,
  }) {
    final channelMessage = getConversationID(senderId: senderId, pairingId: pairingId);

    /// Get message by channel message
    final messages = items.where((element) => element.channelMessage == channelMessage).toList();

    /// Then sort list message by date, to get latest message first
    messages.sort(
        (a, b) => (b.messageDate ?? DateTime.now()).compareTo(a.messageDate ?? DateTime.now()));

    /// We grouped list message by the date
    /// expected result :
    /// 30-08-2021 : [halo say, halo juga say]
    final groupedByDate = groupBy<ChatsMessageModel, DateTime>(messages, (item) {
      final date = item.messageDate ?? DateTime.now();
      return DateTime(date.year, date.month, date.day);
    });

    /// When we get message grouped by date
    /// Then we sort again the list message by date using [SplayTreeMap]
    final result = SplayTreeMap<DateTime, List<ChatsMessageModel>>.from(
        groupedByDate, (a, b) => a.compareTo(b));

    return result;
  }

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;

  ChatsMessageState copyWith({
    List<ChatsMessageModel>? items,
  }) {
    return ChatsMessageState(
      items: items ?? this.items,
    );
  }
}
