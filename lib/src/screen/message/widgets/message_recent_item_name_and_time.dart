import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../network/network.dart';
import '../../../utils/utils.dart';

class MessageRecentItemNameAndTime extends StatelessWidget {
  const MessageRecentItemNameAndTime({
    Key? key,
    required this.recent,
    required this.pairing,
  }) : super(key: key);

  final ChatsRecentModel recent;
  final UserModel pairing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            pairing.name,
            maxLines: 1,
            style: Constant().fontComfortaa.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          timeago.format(recent.recentMessageDate!),
          style: Constant().fontComfortaa.copyWith(
                fontSize: 10.0,
                color: ((recent.countUnreadMessage ?? 0) > 0)
                    ? colorPallete.success
                    : Colors.grey[400]!,
                fontWeight:
                    ((recent.countUnreadMessage ?? 0) > 0) ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}
