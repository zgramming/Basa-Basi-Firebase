import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../global/global_provider.dart';
import '../provider.dart';

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider() : super(const UserModel());

  final FirebaseDatabase _database = FirebaseDatabase();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final provider = StateNotifierProvider<UserProvider, UserModel?>((ref) => UserProvider());

  Future<bool> isAlreadySignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final alreadySignIn = await _googleSignIn.isSignedIn();
    if (!alreadySignIn) {
      state = null;
      return false;
    }
    final idUser = (await _googleSignIn.signIn())?.id;
    final getUser = (await _database.reference().child('users/$idUser').get()).value as Map;
    final user = UserModel.fromJson(Map.from(getUser));
    state = user;

    return true;
  }

  Future<bool> signIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Gagal login dengan Google');
    }
    final user = await _database.reference().child('users/${account.id}').once();
    log('login user provider ${user.value}');
    if (user.value == null) {
      log('login masuk registrasi');
      await _registerUser(account);
    } else {
      log('login langsung masuk');
      final user = UserModel(
        id: account.id,
        name: account.displayName ?? '',
        email: account.email,
        photoUrl: account.photoUrl ?? '',
        isLogin: true,
        loginAt: DateTime.now(),
      );
      state = user;
    }

    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = null;
  }

  Future<void> _registerUser(GoogleSignInAccount? account) async {
    final user = UserModel(
      id: account?.id ?? '',
      name: account?.displayName ?? '',
      email: account?.email ?? '',
      photoUrl: account?.photoUrl ?? '',
      isLogin: true,
      loginAt: DateTime.now(),
    );
    await _database.reference().child('users/${account?.id}').update(user.toJson());

    state = user;
  }
}

final searchUserByEmail = FutureProvider.autoDispose((ref) async {
  final _database = FirebaseDatabase.instance.reference();
  final user = ref.watch(UserProvider.provider);

  final tempList = <UserModel>[];
  final query = ref.watch(searchQueryEmail).state;
  var result = await _database.reference().child('users').limitToFirst(5).get();
  if (query.isNotEmpty) {
    result = await _database.reference().child('users').get();
  }
  log('result search email ${result.value}');

  final map = Map<String, dynamic>.from(result.value as Map);

  for (final value in map.values) {
    final user = UserModel.fromJson(Map.from(value as Map));
    tempList.add(user);
  }

  return tempList
      .where((element) =>
          element.email != user?.email && element.email.toLowerCase().contains(query.toLowerCase()))
      .toList();
});

final searchUserById = FutureProvider.autoDispose.family<UserModel, String>((ref, idUser) async {
  final _database = FirebaseDatabase.instance.reference();
  final result = await _database.child(Constant().childUsers).child(idUser).get();
  final map = Map<String, dynamic>.from(result.value as Map);
  final user = UserModel.fromJson(map);
  return user;
});
