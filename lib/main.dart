import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:rxdart/rxdart.dart';

import './src/app.dart';
import './src/network/network.dart';
import './src/utils/utils.dart';

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  final NotificationHelperRevision _notificationHelper = NotificationHelperRevision();
  log('Handling background service firebase');
  await Firebase.initializeApp();
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
}

final NotificationHelperRevision _notifHelper = NotificationHelperRevision();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _notifHelper.init();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  colorPallete.configuration(
    primaryColor: const Color(0xFF0A4969),
    accentColor: const Color(0xFF00C6B2),
    monochromaticColor: const Color(0xFF3A5984),
    success: const Color(0xFF3D6C31),
    warning: const Color(0xFFF9F871),
    info: const Color(0xFF983E4C),
    error: const Color(0xFF00BBFF),
  );
  runApp(ProviderScope(child: MyApp()));
}
