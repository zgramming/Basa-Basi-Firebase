import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ChatsMessageProvider extends StateNotifier<ChatsMessageState> {
  static final provider = StateNotifierProvider<ChatsMessageProvider, ChatsMessageState>(
      (ref) => ChatsMessageProvider());

  // ignore: constant_identifier_names
  static const CHATS_MESSAGE_PATH = 'chats_message';

  final _database = FirebaseDatabase.instance.reference();
  final _notificationHelper = NotificationHelperRevision();
  final _chatsRecentProvider = ChatsRecentProvider();

  ChatsMessageProvider() : super(const ChatsMessageState());

  Stream<List<ChatsMessageModel>> getMessage(String channelMessage) {
    final chatsReference = _database.child('$CHATS_MESSAGE_PATH/$channelMessage');

    // log('result ${result.value}');
    final messageStream = chatsReference.onValue;

    final result = messageStream.map((event) {
      if (event.snapshot.value != null) {
        final value = event.snapshot.value;
        final messageMap = Map<String, dynamic>.from(value as Map);
        final messageList = messageMap.entries
            .map((e) => ChatsMessageModel.fromJson(Map<String, dynamic>.from(e.value as Map)))
            .toList();
        messageList.sort((a, b) => b.messageDate!.compareTo(a.messageDate!));

        state = state.addAll(messageList);
        return messageList;
      }
      return <ChatsMessageModel>[];
    });

    return result;
  }

  Future<UserModel> getUserByID(String id) async {
    final result = await _database.reference().child('users/$id').get();
    final map = result.value as Map;
    final user = UserModel.fromJson(Map<String, dynamic>.from(map));
    return user;
  }

  Future<String> sendMessage({
    required UserModel? sender,
    required UserModel? pairing,
    required String messageContent,
    String messageReplyId = '',
    MessageType messageType = MessageType.onlyText,
    String urlFile = '',
    List<String> listMessage = const [],
  }) async {
    try {
      final channelMessage =
          getConversationID(senderId: sender?.id ?? '', pairingId: pairing?.id ?? '');

      final messageReference = _database.child('chats_message/$channelMessage').push();
      final id = messageReference.key;

      final messageDate = DateTime.now().millisecondsSinceEpoch;
      final message = ChatsMessageModel(
        id: id,
        senderId: sender?.id ?? '',
        pairingId: pairing?.id ?? '',
        messageContent: messageContent,
        messageDate: DateTime.now(),
        messageReplyId: '',
        messageStatus: MessageStatus.send,
        messageType: messageType,
        channelMessage: channelMessage,
        urlFile: urlFile,
      );

      await messageReference.set(message.toJson());

      await _chatsRecentProvider.saveRecentMessage(
        id: id,
        channelMessage: channelMessage,
        pairingId: pairing?.id ?? '',
        senderId: sender?.id ?? '',
        messageContent: messageContent,
        messageDate: messageDate,
        messageType: messageType,
      );

      if (pairing?.tokenFirebase != null) {
        await _notificationHelper.sendSingleNotificationFirebase(
          pairing?.tokenFirebase ?? '',
          title: sender?.name ?? '',
          body: messageContent,
          paramData: {
            'sender': jsonEncode(sender),
            'messages': jsonEncode(listMessage),
          },
          payload: 'payload messaging from ${sender?.name}',
        );
      }
      return id;
    } catch (e) {
      rethrow;
    }
  }
}

final getMessage =
    StreamProvider.autoDispose.family<List<ChatsMessageModel>, String>((ref, pairingId) {
  final senderId = ref.watch(UserProvider.provider)?.user?.id ?? '';
  final channelMessage = getConversationID(senderId: senderId, pairingId: pairingId);
  final result = ref.watch(ChatsMessageProvider.provider.notifier).getMessage(channelMessage);

  return result;
});
