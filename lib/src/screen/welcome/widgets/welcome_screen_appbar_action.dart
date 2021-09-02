import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../search/search_screen.dart';

class WelcomeScreenAppbarAction extends StatelessWidget {
  const WelcomeScreenAppbarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _selectedRecentChat = ref.watch(SelectedRecentChatProvider.provider).items;
        return Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.center,
          children: [
            if (_selectedRecentChat.isEmpty) ...[
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed(SearchScreen.routeNamed);
                },
                icon: const Icon(FeatherIcons.search),
              ),
            ] else ...[
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
                            value: true,
                          );
                    }
                    ref.read(SelectedRecentChatProvider.provider.notifier).reset();
                  },
                  icon: const Icon(FeatherIcons.archive)),
            ],
          ],
        );
      },
    );
  }
}
