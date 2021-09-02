import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../network/network.dart';
import '../../utils/utils.dart';
import '../global/global_provider.dart';
import '../provider.dart';

class UserProvider extends StateNotifier<UserState> {
  UserProvider() : super(const UserState());

  final _database = FirebaseDatabase();
  final _googleSignIn = GoogleSignIn();

  static final provider = StateNotifierProvider<UserProvider, UserState?>((ref) => UserProvider());

  Future<UserModel?> isAlreadySignIn() async {
    final alreadySignIn = await _googleSignIn.isSignedIn();
    if (!alreadySignIn) {
      state = state.reset();
      return null;
    }
    final idUser = (await _googleSignIn.signIn())?.id;
    final getUser = (await _database.reference().child('users/$idUser').get()).value as Map;
    final user = UserModel.fromJson(Map.from(getUser));
    state = state.setUser(user);

    log('state ${state.user}');
    return user;
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
        tokenFirebase: await FirebaseMessaging.instance.getToken(),
      );
      await _database.reference().child("users/${user.id}").update(user.toJson());
      state = state.setUser(user);
    }

    return true;
  }

  Future<void> signOut(UserModel user) async {
    await _googleSignIn.signOut();
    //TODO: Uncommenct when production release
    await _database.reference().child("users/${user.id}").update(
      {'token_firebase': ''},
    );
    state = state.reset();
  }

  Future<void> _registerUser(GoogleSignInAccount? account) async {
    final user = UserModel(
      id: account?.id ?? '',
      name: account?.displayName ?? '',
      email: account?.email ?? '',
      photoUrl: account?.photoUrl ?? '',
      isLogin: true,
      loginAt: DateTime.now(),
      tokenFirebase: await FirebaseMessaging.instance.getToken(),
    );
    await _database.reference().child('users/${account?.id}').update(user.toJson());

    state = state.setUser(user);
  }
}

final searchUserByEmail = FutureProvider.autoDispose((ref) async {
  final _database = FirebaseDatabase.instance.reference();
  final user = ref.watch(UserProvider.provider)?.user;

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

class UserState extends Equatable {
  final UserModel? user;
  const UserState({
    this.user,
  });

  UserState setUser(UserModel model) => copyWith(user: model);
  UserState reset() => copyWith();

  @override
  List<Object?> get props => [user];

  @override
  bool get stringify => true;

  UserState copyWith({
    UserModel? user,
  }) {
    return UserState(
      user: user ?? this.user,
    );
  }
}
