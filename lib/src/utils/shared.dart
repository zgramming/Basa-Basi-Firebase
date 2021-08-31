import 'package:flutter/material.dart';
import 'package:global_template/functions/global_function.dart';

String getConversationID({required String senderId, required String pairingId}) {
  if (senderId.hashCode <= pairingId.hashCode) {
    // ignore: prefer_interpolation_to_compose_strings
    return senderId + '_' + pairingId;
  } else {
    // ignore: prefer_interpolation_to_compose_strings
    return pairingId + '_' + senderId;
  }
}

Future<void> showLoadingDialog(BuildContext context) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sedang Proses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );

String compareDateMessage(DateTime date) {
  final now = DateTime.now();
  final dateCompared = DateTime(date.year, date.month, date.day, date.hour);
  final dateNow = DateTime(now.year, now.month, now.day, date.hour);
  final diff = dateNow.difference(dateCompared).inDays;
  // log(' Compared : $dateNow - $dateCompared\ndifferent $diff');
  if (diff > 1) {
    return GlobalFunction.formatYMD(dateCompared, type: 3);
  } else if (diff > 0 && diff <= 1) {
    return 'Kemarin';
  } else {
    return 'Hari ini';
  }
}

bool isStillTyping(DateTime now, DateTime? lastTyping) {
  final _lastTyping = lastTyping ?? DateTime.now();
  final diff = _lastTyping.add(const Duration(seconds: 5)).difference(now).inSeconds;
  return diff <= 0;
}

/**
 *  zfefry = 1
 *  kamu = 2
 *  
 *   zeffry ngetik 
 *   1 < 2 = 1_2
 *   kamu ngetik
 *   2 < 1 = 1_2
 * 
 */
