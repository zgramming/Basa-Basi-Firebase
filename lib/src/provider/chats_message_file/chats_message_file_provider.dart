import 'dart:io';

import 'package:basa_basi/src/network/network.dart';
import 'package:basa_basi/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsMessageFileProvider extends StateNotifier<ChatsMessageFileModel> {
  ChatsMessageFileProvider() : super(const ChatsMessageFileModel());
  final _dio = Dio();
  final _database = FirebaseDatabase.instance.reference();

  static final provider = StateNotifierProvider<ChatsMessageFileProvider, ChatsMessageFileModel>(
      (ref) => ChatsMessageFileProvider());

  Future<ChatsMessageFileModel> getMessageFile(String messageId) async {
    final response = await _dio.get(
      '${Constant().baseApi}/getFile',
      queryParameters: {'message_id': messageId},
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    final file = ChatsMessageFileModel.fromJson(json);
    return file;
  }

  Future<ChatsMessageFileModel> sendMessageFile({
    required String senderId,
    required String pairingId,
    required String filename,
    required MessageType messageType,
    required File file,
  }) async {
    final idMessage = getConversationID(senderId: senderId, pairingId: pairingId);

    final messageReference = _database.child('chats_message/$idMessage').push();
    await messageReference.set({});

    final generateMessageId = messageReference.key;
    final formData = FormData.fromMap(
      {
        'generate_message_id': generateMessageId,
        'filename': filename,
        'message_type': MessageTypeValues[messageType],
        'file': MultipartFile.fromFile(file.path),
      },
    );

    final response = await _dio.post(
      '${Constant().baseApi}/sendFile',
      data: formData,
      options: Options(
        validateStatus: (status) => (status ?? 0) < 500,
      ),
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    if (json['status'] != "success") {
      throw Exception(json['message'] as String);
    }
    final result = ChatsMessageFileModel.fromJson(json);
    return result;
  }
}

final getMessageFile =
    FutureProvider.autoDispose.family<ChatsMessageFileModel, String>((ref, messageId) async {
  final result = await ref.read(ChatsMessageFileProvider.provider.notifier).getMessageFile(
        messageId,
      );
  return result;
});
