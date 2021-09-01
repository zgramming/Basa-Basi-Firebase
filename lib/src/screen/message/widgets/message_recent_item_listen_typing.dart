import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Consumer(
          builder: (context, ref, child) {
            final _streamRecentMessage = ref.watch(listenRecentMessage(pairing.id));

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: isStillTyping(
                DateTime.now(),
                _streamRecentMessage.data?.value.lastTypingDate,
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
            );
          },
        ),
      ),
    );
  }
}
