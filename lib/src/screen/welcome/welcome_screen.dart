import 'dart:convert';
import 'dart:developer';

import 'package:basa_basi/src/network/model/user/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../account/account_screen.dart';
import '../message/message_screen.dart';

import './widgets/welcome_screen_appbar_action.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    /// Listen Foreground firebase messaging
    FirebaseMessaging.onMessage.listen((event) {
      log('foreground firebase messaging');
      log('Event foreground firebase messaging : ${event.data}');
      final messages = List<String>.from(jsonDecode(event.data['messages'] as String) as List);
      final decodeSender = jsonDecode(event.data['sender'] as String) as Map<String, dynamic>;
      final sender = UserModel.fromJson(decodeSender);
      final person = Person(key: sender.id, name: sender.name);
      final _list = <Message>[];

      for (final message in messages) {
        _list.add(Message(message, DateTime.now(), person));
      }

      _notificationHelper.showSingleConversationNotification(
        sender.id.hashCode,
        pairing: person,
        messages: _list,
      );
    });

    /// Listen OnOpenedApp firebase messaging
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('foreground firebase messaging');
      log('Event foreground firebase messaging : ${event.data}');
      final messages = List<String>.from(jsonDecode(event.data['messages'] as String) as List);
      final decodeSender = jsonDecode(event.data['sender'] as String) as Map<String, dynamic>;
      final sender = UserModel.fromJson(decodeSender);
      final person = Person(key: sender.id, name: sender.name);
      final _list = <Message>[];

      for (final message in messages) {
        _list.add(Message(message, DateTime.now(), person));
      }

      _notificationHelper.showSingleConversationNotification(
        sender.id.hashCode,
        pairing: person,
        messages: _list,
      );
    });

    /// Listen background firebase messaging
    _notificationHelper.configureDidReceiveLocalNotificationSubject(
      context,
      WelcomeScreen.routeNamed,
    );
    _notificationHelper.configureSelectNotificationSubject(context);
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  final screens = const <Widget>[
    MessageScreen(),
    AccountScreen(),
  ];

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
        actions: [
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
