import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ChatsMessageProvider extends StateNotifier<ChatsMessageState> {
  static final provider = StateNotifierProvider<ChatsMessageProvider, ChatsMessageState>(
      (ref) => ChatsMessageProvider());

  final _database = FirebaseDatabase.instance.reference();
  final ChatsRecentProvider _chatsRecentProvider = ChatsRecentProvider();
  // ignore: constant_identifier_names
  static const CHATS_MESSAGE_PATH = 'chats_message';

  ChatsMessageProvider() : super(const ChatsMessageState());

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

        state = state.addAll(messageList);
        return messageList;
      }
      return <ChatsMessageModel>[];
    });
  }

  Future<String> sendMessage({
    required String senderId,
    required String pairingId,
    required String messageContent,
    String messageReplyId = '',
    MessageType messageType = MessageType.onlyText,
    String urlFile = '',
  }) async {
    try {
      final channelMessage = getConversationID(senderId: senderId, pairingId: pairingId);

      final messageReference = _database.child('chats_message/$channelMessage').push();
      final id = messageReference.key;

      final messageDate = DateTime.now().millisecondsSinceEpoch;

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
        'url_file': urlFile,
      });
      await _chatsRecentProvider.saveRecentMessage(
        id: id,
        channelMessage: channelMessage,
        pairingId: pairingId,
        senderId: senderId,
        messageContent: messageContent,
        messageDate: messageDate,
        messageType: messageType,
      );
      return id;
    } catch (e) {
      rethrow;
    }
  }
}

final getMessage =
    StreamProvider.autoDispose.family<List<ChatsMessageModel>, String>((ref, pairingId) {
  final senderId = ref.watch(UserProvider.provider)?.id ?? '';
  final channelMessage = getConversationID(senderId: senderId, pairingId: pairingId);
  final result = ref.watch(ChatsMessageProvider.provider.notifier).getMessage(channelMessage);

  return result;
});

// final postMessage = FutureProvider.family<void, Map<String, dynamic>>((ref, map) async {
//   final _messageProvider = ref.read(ChatsMessageProvider.provider.notifier);
//   final _recentMessageProvider = ref.read(ChatsRecentProvider.provider.notifier);
//   final channelMessage = getConversationID(
//     senderId: map['senderId'] as String,
//     pairingId: map['pairingId'] as String,
//   );

//   final senderId = map['senderId'] as String;
//   final pairingId = map['pairingId'] as String;
//   final messageContent = map['messageContent'] as String;
//   final messageType = map['messageType'] as MessageType;
//   final messageDate = DateTime.now().millisecondsSinceEpoch;
//   final messageReplyId = map['messageReplyId'] as String;

//   _messageProvider
//       .sendMessage(
//     senderId: senderId,
//     pairingId: pairingId,
//     messageContent: messageContent,
//     messageType: messageType,
//     messageDate: messageDate,
//     messageReplyId: messageReplyId,
//     channelMessage: channelMessage,
//   )
//       .then((id) async {
//     await _recentMessageProvider.saveRecentMessage(
//       id: id,
//       channelMessage: channelMessage,
//       senderId: senderId,
//       messageContent: messageContent,
//       messageDate: messageDate,
//       pairingId: pairingId,
//     );
//   });
// });
