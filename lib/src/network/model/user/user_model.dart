import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  const UserModel({
    this.id = 'nulled',
    this.name = 'nulled',
    this.email = 'nulled',
    this.photoUrl = 'nulled',
    this.isLogin = false,
    this.loginAt,
    this.logoutAt,
  });

  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final bool isLogin;
  final DateTime? loginAt;
  final DateTime? logoutAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List get props {
    return [
      id,
      name,
      email,
      photoUrl,
      isLogin,
      loginAt,
      logoutAt,
    ];
  }

  @override
  bool get stringify => true;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isLogin,
    DateTime? loginAt,
    DateTime? logoutAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isLogin: isLogin ?? this.isLogin,
      loginAt: loginAt ?? this.loginAt,
      logoutAt: logoutAt ?? this.logoutAt,
    );
  }
}
