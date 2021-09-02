import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';

import './message_recent_item.dart';

class MessageRecentsList extends StatefulWidget {
  const MessageRecentsList({
    Key? key,
  }) : super(key: key);

  @override
  _MessageRecentsListState createState() => _MessageRecentsListState();
}

class _MessageRecentsListState extends State<MessageRecentsList> {
  Timer? _timer;

  @override
  void initState() {
    log('init timer welcome page');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
      log('refresh timer welcome page');
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    log('dispose timer welcome page');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final recents = ref.watch(recentMessageArchived(false)).state;
        final userLogin = ref.watch(UserProvider.provider)?.user;
        if (recents.isEmpty) {
          return const Center(
            child: Text('Kamu tidak mempunyai pesan saat ini xD'),
          );
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: recents.length,
          separatorBuilder: (context, index) => Divider(
            endIndent: 10,
            indent: 10,
            color: colorPallete.monochromaticColor?.withOpacity(.5),
          ),
          itemBuilder: (context, index) {
            final recent = recents[index];

            return MessageRecentItem(
              recent: recent,
              userLogin: userLogin,
            );
          },
        );
      },
    );
  }
}
