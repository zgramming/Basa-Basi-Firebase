import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:basa_basi/src/network/network.dart';

part 'chats_recent_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class ChatsRecentModel extends Equatable {
  const ChatsRecentModel({
    this.id = '',
    this.idUser,
    this.channelMessage = '',
    this.recentMessage = '',
    this.messageStatus = MessageStatus.pending,
    this.recentMessageDate,
    this.pairingId = '',
    this.senderId = '',
    this.countUnreadMessage = 0,
    this.isTyping = false,
    this.isArchived = false,
  });

  final String? id;
  final String? idUser;
  final String? channelMessage;
  final String? recentMessage;
  final MessageStatus? messageStatus;
  @JsonKey(
    fromJson: GlobalFunction.fromJsonMilisecondToDateTime,
    toJson: GlobalFunction.toJsonMilisecondFromDateTime,
  )
  final DateTime? recentMessageDate;
  final String? pairingId;
  final String? senderId;
  final int? countUnreadMessage;
  final bool? isTyping;
  final bool? isArchived;

  factory ChatsRecentModel.fromJson(Map<String, dynamic> json) => _$ChatsRecentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsRecentModelToJson(this);

  @override
  List get props {
    return [
      id,
      idUser,
      channelMessage,
      recentMessage,
      messageStatus,
      recentMessageDate,
      pairingId,
      senderId,
      countUnreadMessage,
      isTyping,
      isArchived,
    ];
  }

  @override
  bool get stringify => true;

  ChatsRecentModel copyWith({
    String? id,
    String? idUser,
    String? channelMessage,
    String? recentMessage,
    MessageStatus? messageStatus,
    DateTime? recentMessageDate,
    String? pairingId,
    String? senderId,
    int? countUnreadMessage,
    bool? isTyping,
    bool? isArchived,
  }) {
    return ChatsRecentModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      channelMessage: channelMessage ?? this.channelMessage,
      recentMessage: recentMessage ?? this.recentMessage,
      messageStatus: messageStatus ?? this.messageStatus,
      recentMessageDate: recentMessageDate ?? this.recentMessageDate,
      pairingId: pairingId ?? this.pairingId,
      senderId: senderId ?? this.senderId,
      countUnreadMessage: countUnreadMessage ?? this.countUnreadMessage,
      isTyping: isTyping ?? this.isTyping,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}


// @JsonKey(
//     toJson: GlobalFunction.toJsonStringFromInteger,
//     fromJson: GlobalFunction.fromJsonStringToInteger,
//   )

// factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
// Map<String, dynamic> toJson() => _$UserModelToJson(this);