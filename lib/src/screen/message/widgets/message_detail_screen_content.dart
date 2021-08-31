import 'package:basa_basi/src/provider/provider.dart';
import 'package:basa_basi/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import 'message_detail_screen_list.dart';

class MessageDetailScreenContent extends StatelessWidget {
  const MessageDetailScreenContent({
    Key? key,
    required this.pairingId,
  }) : super(key: key);

  final String pairingId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final senderId = ref.watch(UserProvider.provider)?.id ?? '';
          final _streamMessage = ref.watch(getMessage(pairingId));
          return _streamMessage.when(
            data: (val) {
              final messages = ref.watch(ChatsMessageProvider.provider).chatsByChannel(
                    pairingId: pairingId,
                    senderId: senderId,
                  );
              return SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: messages.entries.map(
                      (map) {
                        final date = map.key;
                        final listMessage = map.value;
                        return Column(
                          children: [
                            Card(
                              color: colorPallete.monochromaticColor,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  compareDateMessage(date),
                                  style: Constant().fontMontserrat.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            MessageDetailScreenList(listMessage: listMessage),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
          );
        },
      ),
    );
  }
}
