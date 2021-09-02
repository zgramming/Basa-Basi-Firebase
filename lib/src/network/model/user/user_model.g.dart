// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    photoUrl: json['photo_url'] as String,
    isLogin: json['is_login'] as bool,
    tokenFirebase: json['token_firebase'] as String?,
    loginAt: json['login_at'] == null
        ? null
        : DateTime.parse(json['login_at'] as String),
    logoutAt: json['logout_at'] == null
        ? null
        : DateTime.parse(json['logout_at'] as String),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo_url': instance.photoUrl,
      'is_login': instance.isLogin,
      'token_firebase': instance.tokenFirebase,
      'login_at': instance.loginAt?.toIso8601String(),
      'logout_at': instance.logoutAt?.toIso8601String(),
    };
