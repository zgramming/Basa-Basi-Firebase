import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../../../network/network.dart';
import '../../../utils/utils.dart';

class MessageRecentItemCountUnread extends StatelessWidget {
  const MessageRecentItemCountUnread({
    Key? key,
    required this.recent,
  }) : super(key: key);

  final ChatsRecentModel recent;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
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
    );
  }
}
