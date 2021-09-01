import 'package:equatable/equatable.dart';

import '../../network/network.dart';

class SessionState extends Equatable {
  final SessionModel session;
  const SessionState({
    this.session = const SessionModel(),
  });

  SessionState setLoginSession({
    required UserModel? value,
  }) =>
      copyWith(session: session.copyWith(user: value));
  SessionState getLoginSession({required UserModel? value}) =>
      copyWith(session: session.copyWith(user: value));

  SessionState setOnboardingSession({
    required bool value,
  }) =>
      copyWith(session: session.copyWith(isAlreadyOnboarding: value));
  SessionState getOnboardingSession({required bool value}) =>
      copyWith(session: session.copyWith(isAlreadyOnboarding: value));

  @override
  List<Object> get props => [session];

  @override
  bool get stringify => true;

  SessionState copyWith({
    SessionModel? session,
  }) {
    return SessionState(
      session: session ?? this.session,
    );
  }
}
