import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';
import '../welcome/widgets/welcome_screen_fab.dart';
import '../welcome/widgets/welcome_screen_info_archive.dart';
import './widgets/message_recent_list.dart';

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
              const WelcomeScreenInfoArchive(),
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
                      data: (_) => const MessageRecentsList(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => Center(child: Text(error.toString())),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const WelcomeScreenFAB(),
      ],
    );
  }
}
