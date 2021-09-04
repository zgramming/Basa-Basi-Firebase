import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageDetailScreenListenTyping extends ConsumerStatefulWidget {
  const MessageDetailScreenListenTyping({Key? key}) : super(key: key);

  @override
  _MessageDetailScreenListenTypingState createState() => _MessageDetailScreenListenTypingState();
}

class _MessageDetailScreenListenTypingState extends ConsumerState<MessageDetailScreenListenTyping> {
  Timer? _timer;
  late final UserModel pairing;
  @override
  void initState() {
    pairing = ref.read(pairingGlobal).state!;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      log('refresh timer Message Detail Listen Typing');
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    log('dispose timer Message Detail Listen Typing');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _streamTyping = ref.watch(listenRecentMessage(pairing.id));
        return _streamTyping.when(
          data: (message) {
            final lastTypingDate = message.lastTypingDate;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.bounceIn,
              switchOutCurve: Curves.bounceOut,
              child: (isStillTyping(lastTypingDate))
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sedang mengetik...',
                        textAlign: TextAlign.left,
                        style: Constant()
                            .fontComfortaa
                            .copyWith(fontSize: 10.0, fontWeight: FontWeight.bold),
                      ),
                    )
                  : const SizedBox(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            log('error $stackTrace');
            return Center(
              child: Text(error.toString()),
            );
          },
        );
      },
    );
  }
}
