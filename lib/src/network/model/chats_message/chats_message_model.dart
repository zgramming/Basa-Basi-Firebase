import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/functions/global_function.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chats_message_model.g.dart';

// ignore: constant_identifier_names
const MessageTypeValues = {
  MessageType.onlyText: 'only_text',
  MessageType.onlyImage: 'only_image',
  MessageType.imageWithText: 'image_with_text',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
};

enum MessageType {
  @JsonValue('only_text')
  onlyText,
  @JsonValue('only_image')
  onlyImage,
  @JsonValue('image_with_text')
  imageWithText,
  @JsonValue('file')
  file,
  @JsonValue('voice')
  voice
}

// ignore: constant_identifier_names
const MessageStatusValues = {
  MessageStatus.none: 'none',
  MessageStatus.pending: 'pending',
  MessageStatus.send: 'send',
  MessageStatus.read: 'read',
};
enum MessageStatus {
  @JsonValue('none')
  none,
  @JsonValue('pending')
  pending,
  @JsonValue('send')
  send,
  @JsonValue('read')
  read
}

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class ChatsMessageModel extends Equatable {
  const ChatsMessageModel({
    this.id = 'nulled',
    this.senderId = 'nulled',
    this.pairingId = '',
    this.messageContent = 'default message',
    this.messageDate,
    this.messageType = MessageType.onlyText,
    this.messageStatus = MessageStatus.pending,
    this.messageReplyId = 'nulled',
    this.channelMessage = '',
  });

  final String id;
  final String senderId;
  final String pairingId;
  final String messageContent;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? messageDate;
  final MessageType messageType;
  final MessageStatus messageStatus;
  final String messageReplyId;
  final String channelMessage;

  factory ChatsMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatsMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsMessageModelToJson(this);

  @override
  List get props {
    return [
      id,
      senderId,
      pairingId,
      messageContent,
      messageDate,
      messageType,
      messageStatus,
      messageReplyId,
      channelMessage,
    ];
  }

  @override
  bool get stringify => true;

  ChatsMessageModel copyWith({
    String? id,
    String? senderId,
    String? pairingId,
    String? messageContent,
    DateTime? messageDate,
    MessageType? messageType,
    MessageStatus? messageStatus,
    String? messageReplyId,
    String? channelMessage,
  }) {
    return ChatsMessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      pairingId: pairingId ?? this.pairingId,
      messageContent: messageContent ?? this.messageContent,
      messageDate: messageDate ?? this.messageDate,
      messageType: messageType ?? this.messageType,
      messageStatus: messageStatus ?? this.messageStatus,
      messageReplyId: messageReplyId ?? this.messageReplyId,
      channelMessage: channelMessage ?? this.channelMessage,
    );
  }
}
