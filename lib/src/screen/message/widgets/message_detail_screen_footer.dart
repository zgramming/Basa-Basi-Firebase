import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';

import '../../../provider/provider.dart';
import './message_detail_screen_modal_image.dart';

class MessageDetailScreenFooter extends StatefulWidget {
  @override
  _MessageDetailScreenFooterState createState() => _MessageDetailScreenFooterState();
}

class _MessageDetailScreenFooterState extends State<MessageDetailScreenFooter> {
  bool _textFieldIsEmpty = true;
  final ImagePicker _picker = ImagePicker();

  final _messageFocusNode = FocusNode();
  final _messageController = TextEditingController();

  final debouncer = Debouncer(milliseconds: 500);
  final _messageReplyId = '';

  Future<void> uploadImage({
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
      builder: (context) {
        return MessageDetailScreenModalImage(file: file);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return TextFormFieldCustom(
                      focusNode: _messageFocusNode,
                      controller: _messageController,
                      disableOutlineBorder: false,
                      radius: 15.0,
                      suffixIconConfiguration: const SuffixIconConfiguration(
                        spacing: 15.0,
                        bottomPosition: 15.0,
                      ),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 5,
                      minLines: 1,
                      suffixIcon: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(FeatherIcons.mic),
                        ),
                        InkWell(
                          onTap: () async {
                            _messageFocusNode.unfocus();
                            await uploadImage(source: ImageSource.camera);
                          },
                          child: const Icon(FeatherIcons.camera),
                        ),
                        if (_textFieldIsEmpty)
                          InkWell(
                            onTap: () {},
                            child: const Icon(Icons.attach_file),
                          ),
                      ],
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 20.0,
                        bottom: 20.0,
                        right: 80,
                      ),
                      onChanged: (value) async {
                        if (value.isNotEmpty && _textFieldIsEmpty) {
                          setState(() => _textFieldIsEmpty = false);
                        }

                        if (value.isEmpty) {
                          setState(() => _textFieldIsEmpty = true);
                        }

                        if (value.length == 1) {
                          try {
                            final userLogin = ref.read(UserProvider.provider)?.user;
                            final _pairingId = ref.read(pairingId).state;

                            await ref
                                .read(ChatsRecentProvider.provider.notifier)
                                .updateTypingStatus(
                                  senderId: userLogin?.id ?? '',
                                  pairingId: _pairingId,
                                  isTyping: true,
                                );
                          } catch (e) {
                            log(e.toString());
                          }
                        } else {
                          debouncer.run(() async {
                            try {
                              final userLogin = ref.read(UserProvider.provider)?.user;
                              final _pairingId = ref.read(pairingId).state;

                              await ref
                                  .read(ChatsRecentProvider.provider.notifier)
                                  .updateTypingStatus(
                                    senderId: userLogin?.id ?? '',
                                    pairingId: _pairingId,
                                    isTyping: true,
                                  );
                            } catch (e) {
                              log(e.toString());
                            }
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 5),
              Consumer(
                builder: (context, ref, child) => InkWell(
                  borderRadius: BorderRadius.circular(60.0),
                  onTap: () async {
                    try {
                      if (_messageController.text.trim().isEmpty) {
                        throw Exception('Pesan tidak boleh kosong');
                      }
                      ref.read(isLoading).state = true;
                      final user = ref.read(UserProvider.provider)?.user;
                      final _pairingId = ref.read(pairingId).state;
                      final messageContent = _messageController.text;
                      _messageController.clear();
                      await ref.read(ChatsMessageProvider.provider.notifier).sendMessage(
                            senderId: user?.id ?? '',
                            pairingId: _pairingId,
                            messageContent: messageContent,
                          );
                      setState(() => _textFieldIsEmpty = true);
                    } catch (e) {
                      GlobalFunction.showSnackBar(
                        context,
                        content: Text(e.toString()),
                        snackBarType: SnackBarType.error,
                      );
                      log('error ${e.toString()}');
                    } finally {
                      ref.read(isLoading).state = false;
                    }
                  },
                  child: Ink(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: colorPallete.success,
                      shape: BoxShape.circle,
                    ),
                    child: const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          FeatherIcons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
