import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../network/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

import '../message_detail_screen.dart';

class MessageRecentItem extends StatelessWidget {
  final bool isSelectedRecentChat;
  final ChatsRecentModel recent;
  final UserModel? userLogin;
  const MessageRecentItem({
    Key? key,
    required this.isSelectedRecentChat,
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
            final _streamRecentMessage = ref.watch(listenRecentMessage(pairing.id));
            return _streamRecentMessage.when(
              data: (message) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Container(
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
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: isSelectedRecentChat
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundColor: colorPallete.accentColor,
                                        foregroundColor: Colors.white,
                                        child: const Icon(FeatherIcons.checkCircle),
                                      )
                                    : SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: pairing.photoUrl,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  pairing.name,
                                                  maxLines: 1,
                                                  style: Constant().fontComfortaa.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                ),
                                              ),
                                              Text(
                                                timeago.format(recent.recentMessageDate!),
                                                style: Constant().fontComfortaa.copyWith(
                                                      fontSize: 10.0,
                                                      color: ((recent.countUnreadMessage ?? 0) > 0)
                                                          ? colorPallete.success
                                                          : Colors.grey[400]!,
                                                      fontWeight:
                                                          ((recent.countUnreadMessage ?? 0) > 0)
                                                              ? FontWeight.bold
                                                              : FontWeight.normal,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        if ((recent.countUnreadMessage ?? 0) <= 0 &&
                                            recent.senderId == (userLogin?.id ?? '')) ...[
                                          SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                for (var i = 0; i < 2; i++)
                                                  Positioned(
                                                    left: i.toDouble() * 5,
                                                    child: Icon(
                                                      FeatherIcons.check,
                                                      size: 14.0,
                                                      color:
                                                          recent.messageStatus == MessageStatus.read
                                                              ? colorPallete.accentColor
                                                              : Colors.black,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 500),
                                                switchInCurve: Curves.easeIn,
                                                switchOutCurve: Curves.easeOut,
                                                child: message.isTyping ?? false
                                                    ? Text(
                                                        'Sedang mengetik...',
                                                        key: UniqueKey(),
                                                        style: Constant().fontComfortaa.copyWith(
                                                              color: colorPallete.accentColor,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 10.0,
                                                            ),
                                                      )
                                                    : Text(
                                                        recent.recentMessage ?? '',
                                                        textAlign: TextAlign.left,
                                                        key: UniqueKey(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: Constant().fontComfortaa.copyWith(
                                                              fontWeight: FontWeight.w200,
                                                              fontSize: 12.0,
                                                              color: Colors.grey[400],
                                                            ),
                                                      ),
                                              )),
                                        ),
                                        const SizedBox(height: 15),
                                        if ((recent.countUnreadMessage ?? 0) > 0)
                                          CircleAvatar(
                                            backgroundColor: colorPallete.success,
                                            foregroundColor: Colors.white,
                                            radius: 10.0,
                                            child: FittedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Text(
                                                  '${recent.countUnreadMessage}',
                                                  style: Constant().fontComfortaa.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                          child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onLongPress: () {
                            ref.read(SelectedRecentChatProvider.provider.notifier).add(message);
                          },
                          onTap: () async {
                            final isEmptySelectedRecentChat =
                                ref.read(SelectedRecentChatProvider.provider).isEmpty;
                            if (!isEmptySelectedRecentChat) {
                              ref.read(SelectedRecentChatProvider.provider.notifier).add(message);
                            } else {
                              try {
                                final channelMessage = getConversationID(
                                  senderId: userLogin?.id ?? '',
                                  pairingId: pairing.id,
                                );
                                await ref
                                    .read(ChatsRecentProvider.provider.notifier)
                                    .resetUnreadMessageCount(
                                      userLogin: userLogin?.id ?? '',
                                      pairingId: pairing.id,
                                      channelMessage: channelMessage,
                                    );
                                Future.delayed(const Duration(milliseconds: 50), () {
                                  Navigator.of(context).pushNamed(
                                    MessageDetailScreen.routeNamed,
                                    arguments: pairing,
                                  );
                                });
                              } catch (e) {
                                log(e.toString());
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
                        ),
                      )),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
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
