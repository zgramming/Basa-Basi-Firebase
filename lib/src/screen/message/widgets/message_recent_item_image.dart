import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';

class MessageRecentItemImage extends StatelessWidget {
  const MessageRecentItemImage({
    Key? key,
    required this.pairing,
    required this.recent,
  }) : super(key: key);

  final UserModel pairing;
  final ChatsRecentModel recent;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isSelectedRecentChat =
            ref.watch(SelectedRecentChatProvider.provider).isExistsSelectedRecentChat(recent);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: isSelectedRecentChat
              ? CircleAvatar(
                  radius: 25,
                  backgroundColor: colorPallete.accentColor,
                  foregroundColor: Colors.white,
                  child: const Icon(FeatherIcons.checkCircle),
                )
              : InkWell(
                  onTap: () => GlobalFunction.showDetailSingleImage(context, url: pairing.photoUrl),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: pairing.photoUrl,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
