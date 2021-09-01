import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';

import '../account/account_screen.dart';
import '../message/message_screen.dart';
import 'widgets/welcome_screen_appbar_action.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
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
