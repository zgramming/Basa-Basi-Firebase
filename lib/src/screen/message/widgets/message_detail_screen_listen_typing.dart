import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageDetailScreenListenTyping extends StatefulWidget {
  const MessageDetailScreenListenTyping({Key? key}) : super(key: key);

  @override
  _MessageDetailScreenListenTypingState createState() => _MessageDetailScreenListenTypingState();
}

class _MessageDetailScreenListenTypingState extends State<MessageDetailScreenListenTyping> {
  Timer? _timer;

  @override
  void initState() {
    log('init timer');
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
      log('refresh timer');
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    log('dispose timer');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _pairingId = ref.watch(pairingId).state;
        final _streamTyping = ref.watch(listenRecentMessage(_pairingId));
        return _streamTyping.when(
          data: (message) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.bounceIn,
              switchOutCurve: Curves.bounceOut,
              child: (isStillTyping(DateTime.now(), message.lastTypingDate))
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
