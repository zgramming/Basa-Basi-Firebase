import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../provider.dart';

class ChatsRecentProvider extends StateNotifier<List<ChatsRecentModel>> {
  ChatsRecentProvider() : super([]);
  static final provider = StateNotifierProvider<ChatsRecentProvider, List<ChatsRecentModel>>(
      (ref) => ChatsRecentProvider());

  final _database = FirebaseDatabase.instance.reference();
  // ignore: constant_identifier_names
  static const CHATS_MESSAGE_RECENT_PATH = 'chats_recent';

  Stream<List<ChatsRecentModel>> getRecentMessage(String idUser) {
    /// Pertimbangan menggunakan [onChildAdded] dibandinglam [onValue]
    /// Untuk meminimalisir refresh / rebuild
    /// Kita tidak ingin refresh halaman depan setiap ada pesan masuk dengan orang yang sama
    /// Tapi kita hanya ingin rebuild ketika ada pesan masuk tapi dengan orang yang baru
    /// Example : Ketika kita sudah pernah chat dengan user "A", lalu kita mengirim pesan kembali ke user "A"
    /// Ketika menggunakan "onValue", halaman depan akan rebuild setiap ada perubahan/penambahan/penghapusan dll pada Tree [chats_recent]
    /// Tetapi ketika menggunakan "onChildAdded", Halaman depan akan rebuild hanya ketika kita melakukan pesan baru dengan orang yang berbeda
    /// Contoh : Kita sudah chat dengan "A", lalu mengirim pesan kembali kepada "A", halaman depan tidak akan melakukan rebuild
    /// Tetapi ketika kita melakukan pesan baru dengan "B", halaman depan akan melakukan rebuild
    log('reference Recent Chat $CHATS_MESSAGE_RECENT_PATH / $idUser');
    final recentChatReferences =
        _database.reference().child('$CHATS_MESSAGE_RECENT_PATH/$idUser').onValue;
    final tempList = <ChatsRecentModel>[];

    final result = recentChatReferences.map((event) {
      if (event.snapshot.value != null) {
        final map = Map<String, dynamic>.from(event.snapshot.value as Map);

        final recentMap = map.entries
            .map((e) => ChatsRecentModel.fromJson(Map<String, dynamic>.from(e.value as Map)))
            .toList();

        state = [...recentMap];

        return tempList;
      }
      return tempList;
    });

    return result;
  }

  Stream<Event> onChildRemove(String idUser) {
    final recentChatReferences =
        _database.reference().child('$CHATS_MESSAGE_RECENT_PATH/$idUser').onChildRemoved;

    // log('On Child Remove Recent Message');
    final result = recentChatReferences.map((event) {
      state = [...state.where((element) => element.id != idUser).toList()];
      return event;
    });

    return result;
  }

  Future<void> saveRecentMessage({
    required String id,
    required String channelMessage,
    required String pairingId,
    required String senderId,
    required String messageContent,
    required MessageType messageType,
    required int messageDate,
  }) async {
    /**
     *  1 < 2 ? 1 : 2
     *  1 > 2 ? 1 : 2
     */
    final referencesSender =
        _database.child('${Constant().childChatsRecent}/$senderId/$channelMessage');
    final referencesPairing =
        _database.child('${Constant().childChatsRecent}/$pairingId/$channelMessage');

    final senderMap = (await referencesSender.get()).value;
    final pairingMap = (await referencesPairing.get()).value;

    ChatsRecentModel? sender, pairing;
    if (senderMap != null && pairingMap != null) {
      sender = ChatsRecentModel.fromJson(Map<String, dynamic>.from(senderMap as Map));
      pairing = ChatsRecentModel.fromJson(Map<String, dynamic>.from(pairingMap as Map));
    }

    /// Save for sender user
    final updateSender = _database.child('chats_recent/$senderId/$channelMessage');
    await updateSender.update(
      {
        'id': id,
        'id_user': senderId,
        'channel_message': channelMessage,

        /// Digunakan untuk memunculkan ceklis 2
        /// Dengan mengetahui siapa pengirimnya
        'sender_id': senderId,

        /// Kawan bicaranya
        'pairing_id': pairingId,
        'recent_message': messageContent,
        'message_type': MessageTypeValues[messageType],
        'recent_message_date': messageDate,
        'count_unread_message': sender?.countUnreadMessage ?? 0,
        'is_archived': sender?.isArchived ?? false,
        'message_status':
            MessageStatusValues[MessageStatus.send] ?? MessageStatusValues[MessageStatus.send],
      },
    );

    /// Save for pairing user
    final updatePairing = _database.child('chats_recent/$pairingId/$channelMessage');

    updatePairing.update(
      {
        'id': id,
        'id_user': pairingId,
        'channel_message': channelMessage,
        'sender_id': senderId,
        'pairing_id': senderId,
        'recent_message': messageContent,
        'message_type': MessageTypeValues[messageType],
        'recent_message_date': messageDate,
        'count_unread_message': (pairing?.countUnreadMessage ?? 0) + 1,
        'is_archived': pairing?.isArchived ?? false,
        'message_status':
            MessageStatusValues[MessageStatus.none] ?? MessageStatusValues[MessageStatus.none],
      },
    );
  }

  Future<void> resetUnreadMessageCount({
    required String userLogin,
    required String pairingId,
    required String channelMessage,
  }) async {
    final senderReference =
        _database.child('${Constant().childChatsRecent}/$userLogin/$channelMessage');
    final pairingReference =
        _database.child('${Constant().childChatsRecent}/$pairingId/$channelMessage');

    final data = await senderReference.get();
    if (data.value != null) {
      /// Get Uniq ID message for update it status message to "read"
      final message = ChatsRecentModel.fromJson(
          Map<String, dynamic>.from((await senderReference.get()).value as Map));
      final messageReference =
          _database.child('${Constant().childChatsMessage}/$channelMessage/${message.id}');

      await messageReference.update({'message_status': MessageStatusValues[MessageStatus.read]});
      await pairingReference.update({'message_status': MessageStatusValues[MessageStatus.read]});
      await senderReference.update({'count_unread_message': 0}).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Sepertinya koneksi kamu tidak stabil ya...'),
      );

      state = [
        for (final item in state)
          if (item.pairingId == pairingId) item.copyWith(countUnreadMessage: 0) else item
      ];
    }
  }

  Future<void> updateTypingStatus({
    required String senderId,
    required String pairingId,
    required bool isTyping,
  }) async {
    final channelMessage = getConversationID(
      senderId: senderId,
      pairingId: pairingId,
    );

    final reference = _database.child('${Constant().childChatsRecent}/$senderId/$channelMessage');
    final data = await reference.get();

    if (data.value != null) {
      await reference.update({
        'is_typing': isTyping,
        'last_typing_date': DateTime.now().millisecondsSinceEpoch,
      });

      state = [
        for (final item in state)
          if (item.id == senderId) item.copyWith(isTyping: isTyping) else item
      ];
    }
  }

  Stream<bool> listenTyping({required String pairingId, required String channelMessage}) {
    final reference = _database
        .child('${Constant().childChatsRecent}/$pairingId/$channelMessage')
        .child('is_typing')
        .onValue;

    final result = reference.map((event) {
      final value = event.snapshot.value as bool;
      return value;
    });

    return result;
  }

  Stream<ChatsRecentModel> listenRecentMessage({
    required String pairingId,
    required String userLoginId,
  }) {
    final channelMessage = getConversationID(senderId: userLoginId, pairingId: pairingId);
    final reference =
        _database.child('${Constant().childChatsRecent}/$pairingId/$channelMessage').onValue;

    final result = reference.map((event) {
      final value = event.snapshot.value;
      if (value != null) {
        final map = Map<String, dynamic>.from(value as Map);
        final recentMessage = ChatsRecentModel.fromJson(map);
        return recentMessage;
      }
      return const ChatsRecentModel();
    });

    return result;
  }

  Future<void> updateArchived({
    required String idUser,
    required String channelMessage,
    required bool value,
  }) async {
    final reference = _database.child('${Constant().childChatsRecent}/$idUser/$channelMessage');
    final data = await reference.get();

    if (data.value != null) {
      await reference.update({
        'is_archived': value,
      }).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Sepertinya koneksi kamu tidak stabil ya...'),
      );

      state = [
        for (final item in state)
          if (item.channelMessage == channelMessage) item.copyWith(isArchived: value) else item
      ];
    }
  }
}

// final initializeRecentMessage = StreamProvider.autoDispose((ref) {
//   final user = ref.watch(UserProvider.provider);

//   /// Listen on Remove
//   // ref.watch(_listenOnChildRemove(user?.id ?? ''));
//   ref.watch(_getRecentMessage(user?.id ?? ''));
//   return Stream.value(true);
// });

final getRecentMessage = StreamProvider.autoDispose<List<ChatsRecentModel>>((ref) {
  final user = ref.watch(UserProvider.provider);

  final result = ref.watch(ChatsRecentProvider.provider.notifier).getRecentMessage(user?.id ?? '');
  ref.onDispose(() {
    log('get recent message on disposed callled');
  });
  return result;
});

final recentMessageArchived =
    StateProvider.autoDispose.family<List<ChatsRecentModel>, bool>((ref, isArchived) {
  final result = ref.watch(ChatsRecentProvider.provider).where((element) {
    final bool archived;
    if (isArchived) {
      archived = true;
    } else {
      archived = false;
    }
    return element.isArchived == archived;
  }).toList();
  return result;
});

final listenTyping = StreamProvider.autoDispose.family<bool, String>((ref, pairingId) {
  final user = ref.watch(UserProvider.provider);
  final channelMessage = getConversationID(senderId: user?.id ?? '', pairingId: pairingId);
  final result = ref
      .watch(ChatsRecentProvider.provider.notifier)
      .listenTyping(pairingId: pairingId, channelMessage: channelMessage);
  return result;
});

final listenRecentMessage =
    StreamProvider.autoDispose.family<ChatsRecentModel, String>((ref, pairingId) {
  final userLogin = ref.watch(UserProvider.provider);
  final result = ref.watch(ChatsRecentProvider.provider.notifier).listenRecentMessage(
        pairingId: pairingId,
        userLoginId: userLogin?.id ?? '',
      );
  return result;
});
