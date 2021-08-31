// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_recent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsRecentModel _$ChatsRecentModelFromJson(Map<String, dynamic> json) {
  return ChatsRecentModel(
    id: json['id'] as String?,
    idUser: json['id_user'] as String?,
    channelMessage: json['channel_message'] as String?,
    recentMessage: json['recent_message'] as String?,
    messageType:
        _$enumDecodeNullable(_$MessageTypeEnumMap, json['message_type']),
    messageStatus:
        _$enumDecodeNullable(_$MessageStatusEnumMap, json['message_status']),
    recentMessageDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['recent_message_date'] as int?),
    lastTypingDate: GlobalFunction.fromJsonMilisecondToDateTime(
        json['last_typing_date'] as int?),
    pairingId: json['pairing_id'] as String?,
    senderId: json['sender_id'] as String?,
    countUnreadMessage: json['count_unread_message'] as int?,
    isTyping: json['is_typing'] as bool?,
    isArchived: json['is_archived'] as bool?,
  );
}

Map<String, dynamic> _$ChatsRecentModelToJson(ChatsRecentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'channel_message': instance.channelMessage,
      'recent_message': instance.recentMessage,
      'message_type': _$MessageTypeEnumMap[instance.messageType],
      'message_status': _$MessageStatusEnumMap[instance.messageStatus],
      'recent_message_date': GlobalFunction.toJsonMilisecondFromDateTime(
          instance.recentMessageDate),
      'last_typing_date':
          GlobalFunction.toJsonMilisecondFromDateTime(instance.lastTypingDate),
      'pairing_id': instance.pairingId,
      'sender_id': instance.senderId,
      'count_unread_message': instance.countUnreadMessage,
      'is_typing': instance.isTyping,
      'is_archived': instance.isArchived,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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
