import 'dart:developer';

import 'package:basa_basi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';

import '../message_detail_screen.dart';
import './message_recent_item_count_unread.dart';
import './message_recent_item_image.dart';
import './message_recent_item_listen_typing.dart';
import './message_recent_item_name_and_time.dart';

class MessageRecentItem extends StatelessWidget {
  final ChatsRecentModel recent;
  final UserModel? userLogin;
  const MessageRecentItem({
    Key? key,
    required this.recent,
    required this.userLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _userFuture = ref.watch(searchUserById(recent.pairingId ?? ''));
        return _userFuture.when(
          data: (pairing) {
            return Stack(
              children: [
                InkWell(
                  onLongPress: () =>
                      ref.read(SelectedRecentChatProvider.provider.notifier).add(recent),
                  onTap: () async {
                    final isEmptySelectedRecentChat =
                        ref.read(SelectedRecentChatProvider.provider).items.isEmpty;
                    if (!isEmptySelectedRecentChat) {
                      ref.read(SelectedRecentChatProvider.provider.notifier).add(recent);
                    } else {
                      try {
                        final senderId = ref.read(UserProvider.provider)?.user?.id ?? '';
                        final channelMessage = getConversationID(
                          senderId: senderId,
                          pairingId: pairing.id,
                        );
                        await ref
                            .read(ChatsRecentProvider.provider.notifier)
                            .resetUnreadMessageCount(
                              userLogin: senderId,
                              pairingId: pairing.id,
                              channelMessage: channelMessage,
                            );

                        ///TODO Save pairing ID to global provider, then we can use on anywhere screen
                        ref.read(pairingId).state = pairing.id;

                        Future.delayed(
                          const Duration(milliseconds: 50),
                          () => Navigator.of(context).pushNamed(
                            MessageDetailScreen.routeNamed,
                            arguments: pairing,
                          ),
                        );
                      } catch (e) {
                        log('Error');
                        GlobalFunction.showSnackBar(
                          context,
                          snackBarType: SnackBarType.error,
                          content: Text(
                            e.toString(),
                          ),
                        );
                      }
                    }
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26),
                        BoxShadow(offset: Offset(0, 1), color: Colors.black26),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 12.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MessageRecentItemImage(pairing: pairing, recent: recent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                MessageRecentItemNameAndTime(
                                  recent: recent,
                                  pairing: pairing,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    if (recent.senderId == (userLogin?.id ?? '')) ...[
                                      CircleAvatar(
                                        radius: 5,
                                        backgroundColor: recent.messageStatus == MessageStatus.read
                                            ? colorPallete.accentColor
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                    MessageRecentItemListenTyping(
                                      recent: recent,
                                      pairing: pairing,
                                    ),
                                    const SizedBox(height: 15),
                                    if ((recent.countUnreadMessage ?? 0) > 0)
                                      MessageRecentItemCountUnread(recent: recent),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
        );
      },
    );
  }
}
