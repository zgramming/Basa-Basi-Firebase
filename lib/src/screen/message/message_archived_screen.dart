import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import './widgets/message_recent_item.dart';

class MessageArchivedScreen extends ConsumerWidget {
  static const routeNamed = '/message-archived';
  const MessageArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              final _selectedRecentChat = ref.read(SelectedRecentChatProvider.provider).items;
              if (_selectedRecentChat.isEmpty) {
                Navigator.of(context).pop();
              }
              ref.read(SelectedRecentChatProvider.provider.notifier).reset();
            },
            icon: const Icon(FeatherIcons.arrowLeft)),
        centerTitle: true,
        title: const Text('Arsip'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider).items;
              return Wrap(
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.center,
                children: [
                  if (_selectedRecentChat.isEmpty)
                    ...[]
                  else ...[
                    Text(
                      '${_selectedRecentChat.length} pesan dipilih',
                      style: Constant().fontComfortaa.copyWith(fontSize: 10.0),
                    ),
                    IconButton(
                      onPressed: () async {
                        final idUser = ref.read(UserProvider.provider)?.user?.id ?? '';
                        for (final chat in _selectedRecentChat) {
                          await ref.read(ChatsRecentProvider.provider.notifier).updateArchived(
                                idUser: idUser,
                                channelMessage: chat.channelMessage ?? '',
                                value: false,
                              );
                        }
                        ref.read(SelectedRecentChatProvider.provider.notifier).reset();
                      },
                      icon: const Icon(
                        Icons.unarchive_rounded,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final recents = ref.watch(recentMessageArchived(true)).state;
          final userLogin = ref.watch(UserProvider.provider)?.user;

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

              return MessageRecentItem(
                recent: recent,
                userLogin: userLogin,
              );
            },
          );
        },
      ),
    );
  }
}
