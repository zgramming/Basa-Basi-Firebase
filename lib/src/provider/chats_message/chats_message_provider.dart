import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:collection/collection.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ChatsMessageProvider extends StateNotifier<List<ChatsMessageModel>> {
  ChatsMessageProvider() : super([]);
  static final provider = StateNotifierProvider<ChatsMessageProvider, List<ChatsMessageModel>>(
      (ref) => ChatsMessageProvider());

  final _database = FirebaseDatabase.instance.reference();

  // ignore: constant_identifier_names
  static const CHATS_MESSAGE_PATH = 'chats_message';

  Stream<List<ChatsMessageModel>> getMessage(String channelMessage) {
    final chatsReference = _database.child('$CHATS_MESSAGE_PATH/$channelMessage');

    // log('result ${result.value}');
    final messageStream = chatsReference.onValue;
    return messageStream.map((event) {
      if (event.snapshot.value != null) {
        final value = event.snapshot.value;
        final messageMap = Map<String, dynamic>.from(value as Map);
        final messageList = messageMap.entries
            .map((e) => ChatsMessageModel.fromJson(Map<String, dynamic>.from(e.value as Map)))
            .toList();
        messageList.sort((a, b) => b.messageDate!.compareTo(a.messageDate!));
        state = [...messageList];
        return messageList;
      }
      return <ChatsMessageModel>[];
    });
  }

  Future<String> sendMessage({
    required String senderId,
    required String pairingId,
    required String messageContent,
    required MessageType messageType,
    required int messageDate,
    required String messageReplyId,
    required String channelMessage,
  }) async {
    final channelMessage = getConversationID(senderId: senderId, pairingId: pairingId);
    final messageReference = _database.child('chats_message/$channelMessage').push();
    final id = messageReference.key;
    await messageReference.set({
      'id': id,
      'sender_id': senderId,
      'pairing_id': pairingId,
      'message_content': messageContent,
      'message_date': messageDate,
      'message_type': MessageTypeValues[messageType],
      'message_status': MessageStatusValues[MessageStatus.send],
      'message_reply_id': messageReplyId,
      'channel_message': channelMessage,
    });
    return id;
  }
}

final getMessage =
    StreamProvider.autoDispose.family<List<ChatsMessageModel>, String>((ref, channelMessage) {
  final result = ref.watch(ChatsMessageProvider.provider.notifier).getMessage(channelMessage);

  return result;
});

final messageById = StateProvider.autoDispose
    .family<Map<DateTime, List<ChatsMessageModel>>, String>((ref, channelMessage) {
  final result = ref.watch(ChatsMessageProvider.provider).where((element) {
    return element.channelMessage == channelMessage;
  }).toList();
  result
      .sort((a, b) => (b.messageDate ?? DateTime.now()).compareTo(a.messageDate ?? DateTime.now()));

  final groupedByDate = groupBy<ChatsMessageModel, DateTime>(result, (item) {
    final date = item.messageDate ?? DateTime.now();
    return DateTime(date.year, date.month, date.day);
  });

  final st =
      SplayTreeMap<DateTime, List<ChatsMessageModel>>.from(groupedByDate, (a, b) => a.compareTo(b));

  // groupedByDate.entries.map((e) {
  //   log('key ${e.key}');
  //   log('value ${e.value}');
  // });
  return st;
});

final postMessage = FutureProvider.family<void, Map<String, dynamic>>((ref, map) async {
  final _messageProvider = ref.read(ChatsMessageProvider.provider.notifier);
  final _recentMessageProvider = ref.read(ChatsRecentProvider.provider.notifier);
  final channelMessage = getConversationID(
    senderId: map['senderId'] as String,
    pairingId: map['pairingId'] as String,
  );

  final senderId = map['senderId'] as String;
  final pairingId = map['pairingId'] as String;
  final messageContent = map['messageContent'] as String;
  final messageType = map['messageType'] as MessageType;
  final messageDate = DateTime.now().millisecondsSinceEpoch;
  final messageReplyId = map['messageReplyId'] as String;

  _messageProvider
      .sendMessage(
    senderId: senderId,
    pairingId: pairingId,
    messageContent: messageContent,
    messageType: messageType,
    messageDate: messageDate,
    messageReplyId: messageReplyId,
    channelMessage: channelMessage,
  )
      .then((id) async {
    await _recentMessageProvider.saveRecentMessage(
      id: id,
      channelMessage: channelMessage,
      senderId: senderId,
      messageContent: messageContent,
      messageDate: messageDate,
      pairingId: pairingId,
    );
  });
});
