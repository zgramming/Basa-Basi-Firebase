import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../account/account_screen.dart';
import '../login/login_screen.dart';
import '../message/message_screen.dart';
import '../search/search_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider);
            if (_selectedRecentChat.isNotEmpty) {
              return IconButton(
                onPressed: () {
                  ref.read(SelectedRecentChatProvider.provider.notifier).reset();
                },
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
          Consumer(
            builder: (context, ref, child) {
              final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider);
              return Wrap(
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.center,
                children: [
                  if (_selectedRecentChat.isEmpty) ...[
                    IconButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed(SearchScreen.routeNamed);
                        },
                        icon: const Icon(FeatherIcons.search)),
                    PopupMenuButton(
                      onSelected: (value) async {
                        switch (value) {
                          case 'sign_out':
                            final result = await _googleSignIn.signOut();
                            log('result logout ${result?.email}');
                            Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                            break;
                          case 'test_firebase':
                            // final result = database.child('path');
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context) => [],
                    ),
                  ] else ...[
                    Text(
                      '${_selectedRecentChat.length} pesan dipilih',
                      style: Constant().fontComfortaa.copyWith(fontSize: 10.0),
                    ),
                    IconButton(
                        onPressed: () async {
                          final idUser = ref.read(UserProvider.provider)?.id ?? '';
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
          ),
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
