import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../message/message_archived_screen.dart';

class WelcomeScreenInfoArchive extends StatelessWidget {
  const WelcomeScreenInfoArchive({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
                side: BorderSide(color: colorPallete.accentColor!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FeatherIcons.archive, color: colorPallete.accentColor),
                  const SizedBox(width: 10),
                  Text(
                    '${recentMessage.length} pesan diarsipkan',
                    style: Constant().fontComfortaa.copyWith(color: colorPallete.accentColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
