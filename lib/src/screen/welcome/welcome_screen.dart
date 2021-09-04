import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:rxdart/subjects.dart';

import '../../../main.dart';
import '../../network/network.dart';
import '../../provider/provider.dart';
import '../../utils/notification/notification_helper.dart';
import '../account/account_screen.dart';
import '../message/message_detail_screen.dart';
import '../message/message_screen.dart';
import './widgets/welcome_screen_appbar_action.dart';

///TODO: Documentation, must read this for easier your life
/// Documentation
/// 1. Where widget location have function to navigate to MessageDetailScreen.routeNamed ?
/// Answer : [1.message_recent_item.dart, 2.search_result]
/// 2. Where location timer to refresh screen every 4 second ?
/// Answer : [1.message_recent_list.dart, 2.message_detail_listen_typing]

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  int _selectedIndex = 0;

  final screens = const <Widget>[
    MessageScreen(),
    AccountScreen(),
  ];

  final _notificationHelper = NotificationHelperRevision();

  @override
  void initState() {
    super.initState();

    /// When user sign-out, it will close stream then we can't listen notification anymore
    /// Then we should re-open stream again after sign-in
    selectNotificationSubject = BehaviorSubject<String?>();
    didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

    log('selectNotificationSubject is Closed : ${selectNotificationSubject.isClosed}');
    _notificationHelper.requestPermissions();
    _notificationHelper.configureDidReceiveLocalNotificationSubject(context);
    _notificationHelper.configureSelectNotificationSubject(
      context,
      onSelectNotification: (pairing) {
        ref.read(pairingGlobal).state = pairing;

        ///* We should reset count unread message when tap notification
        final userLogin = ref.read(UserProvider.provider)?.user;
        ref.read(ChatsRecentProvider.provider.notifier).resetUnreadMessageCount(
              userLogin: userLogin?.id ?? '',
              pairingId: pairing.id,
            );
        Navigator.pushNamed(context, MessageDetailScreen.routeNamed);
      },
    );

    /// Listen Foreground firebase messaging
    FirebaseMessaging.onMessage.listen((event) {
      log('onmessage firebase messaging');
      log('Event foreground firebase messaging : ${event.data}');
      final messages = List<String>.from(jsonDecode(event.data['messages'] as String) as List);
      final decodeSender = jsonDecode(event.data['sender'] as String) as Map<String, dynamic>;
      final sender = UserModel.fromJson(decodeSender);

      _notificationHelper
          .downloadAndSaveFile(sender.photoUrl, '${sender.id}_${sender.name}')
          .then((urlFile) {
        final person = Person(
          key: sender.id,
          name: sender.name,
          icon: BitmapFilePathAndroidIcon(urlFile),
        );

        final _list = <Message>[];

        for (final message in messages) {
          _list.add(Message(message, DateTime.now(), person));
        }

        _notificationHelper.showSingleConversationNotification(
          sender.id.hashCode,
          pairing: person,
          messages: _list,
          payload: event.data['sender'] as String,
        );
      });
    });

    /// Listen OnOpenedApp firebase messaging
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('onmessageopenedapp firebase messaging');
      log('Event foreground firebase messaging : ${event.data}');
      final messages = List<String>.from(jsonDecode(event.data['messages'] as String) as List);
      final decodeSender = jsonDecode(event.data['sender'] as String) as Map<String, dynamic>;
      final sender = UserModel.fromJson(decodeSender);

      _notificationHelper
          .downloadAndSaveFile(sender.photoUrl, '${sender.id}_${sender.name}')
          .then((urlFile) {
        final person = Person(
          key: sender.id,
          name: sender.name,
          icon: BitmapFilePathAndroidIcon(urlFile),
        );

        final _list = <Message>[];

        for (final message in messages) {
          _list.add(Message(message, DateTime.now(), person));
        }

        _notificationHelper.showSingleConversationNotification(
          sender.id.hashCode,
          pairing: person,
          messages: _list,
          payload: event.data['sender'] as String,
        );
      });
    });
  }

  @override
  void dispose() {
    /// Close stream to prevent memory leak;
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        title: Consumer(
          builder: (context, ref, child) {
            final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider).items;
            if (_selectedRecentChat.isNotEmpty) {
              return IconButton(
                onPressed: () => ref.read(SelectedRecentChatProvider.provider.notifier).reset(),
                icon: const Icon(FeatherIcons.arrowLeft),
              );
            }
            return Image.asset(
              '${appConfig.urlImageAsset}/logo_white.png',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            );
          },
        ),
        actions: const [
          WelcomeScreenAppbarAction(),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showUnselectedLabels: false,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(
                FeatherIcons.messageCircle,
                color: colorPallete.accentColor,
              ),
            ),
            icon: const Icon(FeatherIcons.messageCircle),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Icon(
                FeatherIcons.user,
                color: colorPallete.accentColor,
              ),
            ),
            icon: const Icon(FeatherIcons.user),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
