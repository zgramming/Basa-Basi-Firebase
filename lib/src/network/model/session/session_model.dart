import 'package:equatable/equatable.dart';

import 'package:basa_basi/src/network/model/user/user_model.dart';

class SessionModel extends Equatable {
  const SessionModel({
    this.isAlreadyOnboarding = false,
    this.user,
  });
  final bool isAlreadyOnboarding;
  final UserModel? user;

  @override
  List<Object?> get props => [isAlreadyOnboarding, user];

  @override
  bool get stringify => true;

  SessionModel copyWith({
    bool? isAlreadyOnboarding,
    UserModel? user,
  }) {
    return SessionModel(
      isAlreadyOnboarding: isAlreadyOnboarding ?? this.isAlreadyOnboarding,
      user: user ?? this.user,
    );
  }
}
