import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/network.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';

import './widgets/message_detail_screen_content.dart';
import './widgets/message_detail_screen_footer.dart';

class MessageDetailScreen extends StatelessWidget {
  static const routeNamed = '/message-detail-screen';
  final UserModel? pairing;
  const MessageDetailScreen({
    Key? key,
    required this.pairing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
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
                          pairing?.photoUrl ?? '',
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
                    Align(alignment: Alignment.centerLeft, child: Text(pairing?.name ?? '')),
                    Consumer(
                      builder: (context, ref, child) {
                        final _streamTyping = ref.watch(listenRecentMessage(pairing?.id ?? ''));
                        return _streamTyping.when(
                          data: (message) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              switchInCurve: Curves.bounceIn,
                              switchOutCurve: Curves.bounceOut,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final clock =
                                      ref.watch(realtimeClock).data?.value ?? DateTime.now();
                                  return (isStillTyping(clock, message.lastTypingDate))
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Sedang mengetik...',
                                            textAlign: TextAlign.left,
                                            style: Constant().fontComfortaa.copyWith(
                                                fontSize: 10.0, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : const SizedBox();
                                },
                              ),
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) {
                            log('error $stackTrace');
                            return Center(
                              child: Text(error.toString()),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [const PopupMenuItem(child: Text('Hapus chat'))],
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessageDetailScreenContent(pairingId: pairing?.id ?? ''),
            const SizedBox(height: 10.0),
            MessageDetailScreenFooter(),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
