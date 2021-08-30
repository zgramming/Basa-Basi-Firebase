import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../network.dart';

part 'chats_message_file_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class ChatsMessageFileModel extends Equatable {
  const ChatsMessageFileModel({
    this.id,
    this.generateMessageId = '',
    this.filename = '',
    this.messageType = MessageType.onlyText,
    this.createDate,
  });

  @JsonKey(
    toJson: GlobalFunction.toJsonStringFromInteger,
    fromJson: GlobalFunction.fromJsonStringToInteger,
  )
  final int? id;
  final String generateMessageId;
  final String filename;
  final MessageType messageType;
  final DateTime? createDate;

  factory ChatsMessageFileModel.fromJson(Map<String, dynamic> json) =>
      _$ChatsMessageFileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatsMessageFileModelToJson(this);

  @override
  List get props {
    return [
      id,
      generateMessageId,
      filename,
      messageType,
      createDate,
    ];
  }

  @override
  bool get stringify => true;

  ChatsMessageFileModel copyWith({
    int? id,
    String? generateMessageId,
    String? filename,
    MessageType? messageType,
    DateTime? createDate,
  }) {
    return ChatsMessageFileModel(
      id: id ?? this.id,
      generateMessageId: generateMessageId ?? this.generateMessageId,
      filename: filename ?? this.filename,
      messageType: messageType ?? this.messageType,
      createDate: createDate ?? this.createDate,
    );
  }
}
