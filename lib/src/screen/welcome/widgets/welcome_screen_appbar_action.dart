import 'dart:convert';

import 'package:basa_basi/src/network/network.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../search/search_screen.dart';

class WelcomeScreenAppbarAction extends StatelessWidget {
  WelcomeScreenAppbarAction({Key? key}) : super(key: key);

  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider).items;
        return Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.center,
          children: [
            if (_selectedRecentChat.isEmpty) ...[
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(SearchScreen.routeNamed);
                },
                icon: const Icon(FeatherIcons.search),
              ),
              IconButton(
                onPressed: () async {
                  final _database = FirebaseDatabase.instance.reference();
                  final result = await _database
                      .child(Constant().childUsers)
                      .child('111395227810958186033')
                      .get();
                  final map = Map<String, dynamic>.from(result.value as Map);
                  final user = UserModel.fromJson(map);

                  await _notificationHelper.sendSingleNotificationFirebase(
                    "fOrIMgnSR8ebZ_5MFkTI5W:APA91bFSZOOY_cr1SsjE-vu2cbG0hr6p7J55cFq1fUnUn5a-zij65ntslvlCysCjxt25FtI7VWrloFHrVVmWYxObDGLoqefzziJbYCXbEhNpn0cn7mx7BQspa3EawzGEOy32rr0PgTV_",
                    title: 'Testing title',
                    body: 'Testing Body',
                    paramData: {
                      'pairing': jsonEncode(user),
                      'path-image':
                          await _notificationHelper.downloadAndSaveFile(user.photoUrl, user.id)
                    },
                  );
                  // _notificationHelper.showNotification(
                  //   id: 1,
                  //   title: 'Test',
                  //   description: 'Deskripsi Test',
                  //   payload: 'test Payload',
                  // );
                },
                icon: const Icon(FeatherIcons.messageCircle),
              ),
            ] else ...[
              Text(
                '${_selectedRecentChat.length} pesan dipilih',
                style: Constant().fontComfortaa.copyWith(fontSize: 10.0),
              ),
              IconButton(
                  onPressed: () async {
                    final idUser = ref.read(UserProvider.provider)?.user?.id ?? '';
                    for (final chat in _selectedRecentChat) {
                      await ref.read(ChatsRecentProvider.provider.notifier).updateArchived(
                            idUser: idUser,
                            channelMessage: chat.channelMessage ?? '',
                            value: true,
                          );
                    }
                    ref.read(SelectedRecentChatProvider.provider.notifier).reset();
                  },
                  icon: const Icon(FeatherIcons.archive)),
            ],
          ],
        );
      },
    );
  }
}
