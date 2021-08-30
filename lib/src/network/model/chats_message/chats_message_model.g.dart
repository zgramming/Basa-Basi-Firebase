// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsMessageModel _$ChatsMessageModelFromJson(Map<String, dynamic> json) {
  return ChatsMessageModel(
    id: json['id'] as String,
    senderId: json['sender_id'] as String,
    pairingId: json['pairing_id'] as String,
    messageContent: json['message_content'] as String,
    messageDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['message_date'] as int),
    messageType: _$enumDecode(_$MessageTypeEnumMap, json['message_type']),
    messageStatus: _$enumDecode(_$MessageStatusEnumMap, json['message_status']),
    messageReplyId: json['message_reply_id'] as String,
    channelMessage: json['channel_message'] as String,
  );
}

Map<String, dynamic> _$ChatsMessageModelToJson(ChatsMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'pairing_id': instance.pairingId,
      'message_content': instance.messageContent,
      'message_date':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.messageDate),
      'message_type': _$MessageTypeEnumMap[instance.messageType],
      'message_status': _$MessageStatusEnumMap[instance.messageStatus],
      'message_reply_id': instance.messageReplyId,
      'channel_message': instance.channelMessage,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$MessageTypeEnumMap = {
  MessageType.onlyText: 'only_text',
  MessageType.onlyImage: 'only_image',
  MessageType.imageWithText: 'image_with_text',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
};

const _$MessageStatusEnumMap = {
  MessageStatus.none: 'none',
  MessageStatus.pending: 'pending',
  MessageStatus.send: 'send',
  MessageStatus.read: 'read',
};
