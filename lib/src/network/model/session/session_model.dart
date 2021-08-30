import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  const SessionModel({
    this.isAlreadyOnboarding = false,
  });
  final bool isAlreadyOnboarding;

  @override
  List<Object> get props => [isAlreadyOnboarding];

  @override
  bool get stringify => true;

  SessionModel copyWith({
    bool? isAlreadyOnboarding,
  }) {
    return SessionModel(
      isAlreadyOnboarding: isAlreadyOnboarding ?? this.isAlreadyOnboarding,
    );
  }
}
