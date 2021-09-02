import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:global_template/functions/global_function.dart';
import 'package:image_picker/image_picker.dart';

import '../screen/message/widgets/message_detail_screen_modal_image.dart';

final ImagePicker _picker = ImagePicker();

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

bool isStillTyping(DateTime? lastTyping) {
  if (lastTyping != null) {
    final diff = lastTyping.add(const Duration(seconds: 5)).difference(DateTime.now()).inSeconds;
    log('diff $diff');
    return diff >= 0;
  }
  return false;
}

Future<void> uploadImage(
  BuildContext context, {
  ImageSource source = ImageSource.gallery,
}) async {
  final file = await _picker.pickImage(
    source: source,
    // maxHeight: 300,
    // maxWidth: 300,
    imageQuality: 10,
  );

  if (file == null) {
    log('Tidak menemukan gambar yang dipilih');
    return;
  }
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) {
      return MessageDetailScreenModalImage(file: file);
    },
  );
}

Future<File?> pickFile() async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return null;
  }
  return File(result.files.single.path);
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
