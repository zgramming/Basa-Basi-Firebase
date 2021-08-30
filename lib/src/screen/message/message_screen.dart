import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../search/search_screen.dart';

import './message_archived_screen.dart';
import './widgets/message_recent.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final recentMessage = ref.watch(recentMessageArchived(true)).state;
                  if (recentMessage.isEmpty) {
                    return const SizedBox();
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          final recentMessage = ref.read(recentMessageArchived(true)).state;
                          if (recentMessage.isNotEmpty) {
                            Navigator.of(context).pushNamed(MessageArchivedScreen.routeNamed);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorPallete.accentColor!)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FeatherIcons.archive, color: colorPallete.accentColor),
                            const SizedBox(width: 10),
                            Text(
                              recentMessage.isEmpty
                                  ? 'Arsip'
                                  : '${recentMessage.length} diarsipkan',
                              style: Constant()
                                  .fontComfortaa
                                  .copyWith(color: colorPallete.accentColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Pesan',
                style: Constant().fontMontserrat.copyWith(fontSize: 18.0),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final _streamRecentMessage = ref.watch(getRecentMessage);

                    return _streamRecentMessage.when(
                      data: (_) => const MessageRecents(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => Center(child: Text(error.toString())),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).pushNamed(SearchScreen.routeNamed);
            },
            borderRadius: BorderRadius.circular(60.0),
            child: Container(
              height: 55.0,
              width: 55.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorPallete.accentColor,
              ),
              child: const FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    FeatherIcons.messageSquare,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
