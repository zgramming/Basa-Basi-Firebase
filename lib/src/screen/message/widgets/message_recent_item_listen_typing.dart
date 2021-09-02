import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageRecentItemListenTyping extends StatelessWidget {
  const MessageRecentItemListenTyping({
    Key? key,
    required this.recent,
    required this.pairing,
  }) : super(key: key);
  final ChatsRecentModel recent;
  final UserModel pairing;

  Widget showMessage(ChatsRecentModel recent) {
    Widget widget = const SizedBox();

    switch (recent.messageType) {
      case MessageType.onlyText:
        widget = Text(
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
        );
        break;
      case MessageType.imageWithText:
      case MessageType.onlyImage:
        widget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FeatherIcons.image),
            const SizedBox(width: 10),
            Text(
              'Mengirim gambar',
              style: Constant().fontComfortaa.copyWith(
                    fontWeight: FontWeight.w200,
                    fontSize: 12.0,
                    color: Colors.grey[400],
                  ),
            ),
          ],
        );
        break;
      case MessageType.file:
        widget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FeatherIcons.file),
            const SizedBox(width: 10),
            Text(
              'Mengirim File',
              style: Constant().fontComfortaa.copyWith(
                    fontWeight: FontWeight.w200,
                    fontSize: 12.0,
                    color: Colors.grey[400],
                  ),
            ),
          ],
        );
        break;
      case MessageType.voice:
        widget = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(FeatherIcons.mic),
            const SizedBox(width: 10),
            Text(
              'Mengirim pesan suara',
              style: Constant().fontComfortaa.copyWith(
                    fontWeight: FontWeight.w200,
                    fontSize: 12.0,
                    color: Colors.grey[400],
                  ),
            ),
          ],
        );
        break;
      default:
        widget = const SizedBox();
        break;
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Consumer(
          builder: (context, ref, child) {
            final _streamRecentMessage = ref.watch(listenRecentMessage(pairing.id));
            final lastTypingDate = _streamRecentMessage.data?.value.lastTypingDate;
            return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: isStillTyping(
                  lastTypingDate,
                )
                    ? Text(
                        'Sedang mengetik...',
                        key: UniqueKey(),
                        style: Constant().fontComfortaa.copyWith(
                              color: colorPallete.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                      )
                    : showMessage(recent));
          },
        ),
      ),
    );
  }
}
