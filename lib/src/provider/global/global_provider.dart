import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoading = StateProvider.autoDispose<bool>((ref) => false);

final searchQueryEmail = StateProvider.autoDispose<String>((ref) => '');
