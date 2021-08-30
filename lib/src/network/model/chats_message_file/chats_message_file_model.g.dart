// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_message_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsMessageFileModel _$ChatsMessageFileModelFromJson(
    Map<String, dynamic> json) {
  return ChatsMessageFileModel(
    id: GlobalFunction.fromJsonStringToInteger(json['id']),
    generateMessageId: json['generate_message_id'] as String,
    filename: json['filename'] as String,
    messageType: _$enumDecode(_$MessageTypeEnumMap, json['message_type']),
    createDate: json['create_date'] == null
        ? null
        : DateTime.parse(json['create_date'] as String),
  );
}

Map<String, dynamic> _$ChatsMessageFileModelToJson(
        ChatsMessageFileModel instance) =>
    <String, dynamic>{
      'id': GlobalFunction.toJsonStringFromInteger(instance.id),
      'generate_message_id': instance.generateMessageId,
      'filename': instance.filename,
      'message_type': _$MessageTypeEnumMap[instance.messageType],
      'create_date': instance.createDate?.toIso8601String(),
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
