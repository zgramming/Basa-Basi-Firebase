import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/network.dart';
import '../../provider/provider.dart';

import './widgets/message_detail_screen_content.dart';
import './widgets/message_detail_screen_footer.dart';
import './widgets/message_detail_screen_listen_typing.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/message-detail-screen';
  const MessageDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen> {
  late final UserModel pairing;
  @override
  void initState() {
    ///* Every user enter message screen, reset previous temporary messages
    super.initState();
    pairing = ref.read(pairingGlobal).state!;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // Add Your Code here.
      ref.read(tempListMessages.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(30.0),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.arrowLeft),
                    const SizedBox(width: 5),
                    Ink(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorPallete.accentColor,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          pairing.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft, child: Text(pairing.name)),
                    const MessageDetailScreenListenTyping(),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessageDetailScreenContent(pairingId: pairing.id),
            const SizedBox(height: 10.0),
            MessageDetailScreenFooter(),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
