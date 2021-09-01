import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoading = StateProvider.autoDispose<bool>((ref) => false);

final searchQueryEmail = StateProvider.autoDispose<String>((ref) => '');

final pairingId = StateProvider<String>((ref) => '');

final realtimeClock = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 4), (_) {
    return DateTime.now();
  });
});
