import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';

import './message_recent_item.dart';

class MessageRecents extends ConsumerWidget {
  const MessageRecents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recents = ref.watch(recentMessageArchived(false)).state;
    final userLogin = ref.watch(UserProvider.provider);
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
        final isExists = ref.watch(isExistsSelectedRecentChat(recent)).state;
        return MessageRecentItem(
          isSelectedRecentChat: isExists,
          recent: recent,
          userLogin: userLogin,
        );
      },
    );
  }
}
