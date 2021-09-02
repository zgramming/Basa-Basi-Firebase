import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../network/model/chats_message/chats_message_model.dart';
import '../../../provider/provider.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class MessageDetailScreenFooter extends StatefulWidget {
  @override
  _MessageDetailScreenFooterState createState() => _MessageDetailScreenFooterState();
}

class _MessageDetailScreenFooterState extends State<MessageDetailScreenFooter> {
  final List<String> _listMessages = [];

  bool _textFieldIsEmpty = true;

  final _messageFocusNode = FocusNode();
  final _messageController = TextEditingController();

  final debouncer = Debouncer(milliseconds: 500);
  final _messageReplyId = '';

  @override
  void initState() {
    super.initState();
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
                        Visibility(
                          visible: false,
                          child: InkWell(
                            onTap: () {},
                            child: const Icon(FeatherIcons.mic),
                          ),
                        ),
                        if (_textFieldIsEmpty)
                          InkWell(
                            onTap: () async {
                              _messageFocusNode.unfocus();
                              await uploadImage(context, source: ImageSource.camera);
                            },
                            child: const Icon(FeatherIcons.camera),
                          ),
                        InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24.0),
                                child: Wrap(
                                  spacing: 20.0,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: sizes.width(context) / 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ActionCircleButton(
                                            icon: FeatherIcons.camera,
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            onTap: () async {
                                              /// Tutup modal bottom sheet sebelum membuka kamera/gallery
                                              Navigator.of(context).pop();
                                              _messageFocusNode.unfocus();
                                              await uploadImage(
                                                context,
                                                source: ImageSource.camera,
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          FittedBox(
                                            child: Text(
                                              'Kamera',
                                              style: Constant()
                                                  .fontComfortaa
                                                  .copyWith(color: Colors.grey[400]),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: sizes.width(context) / 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ActionCircleButton(
                                            icon: FeatherIcons.image,
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            onTap: () async {
                                              /// Tutup modal bottom sheet sebelum membuka kamera/gallery
                                              Navigator.of(context).pop();
                                              _messageFocusNode.unfocus();
                                              await uploadImage(context);
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          FittedBox(
                                            child: Text(
                                              'Galeri',
                                              style: Constant()
                                                  .fontComfortaa
                                                  .copyWith(color: Colors.grey[400]),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: sizes.width(context) / 8,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ActionCircleButton(
                                              icon: FeatherIcons.file,
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                              onTap: () async {
                                                try {
                                                  ref.read(isLoading).state = true;
                                                  final _pairingId = ref.read(pairingId).state;

                                                  final sender =
                                                      ref.read(UserProvider.provider)?.user;
                                                  final pairing = await ref
                                                      .read(ChatsMessageProvider.provider.notifier)
                                                      .getUserByID(_pairingId);

                                                  final FilePickerResult? result =
                                                      await FilePicker.platform.pickFiles();
                                                  if (result == null) {
                                                    return;
                                                  }
                                                  final file = File(result.files.single.path);
                                                  final filename = basename(file.path);
                                                  final firebase_storage.Reference reference =
                                                      firebase_storage.FirebaseStorage.instance
                                                          .ref()
                                                          .child('file/')
                                                          .child(filename);

                                                  await reference.putFile(File(file.path));

                                                  final urlFile =
                                                      (await reference.getDownloadURL()).toString();
                                                  log('UrlFile $urlFile');

                                                  await ref
                                                      .read(ChatsMessageProvider.provider.notifier)
                                                      .sendMessage(
                                                        sender: sender,
                                                        pairing: pairing,
                                                        messageContent: '',
                                                        urlFile: urlFile,
                                                        messageType: MessageType.file,
                                                      );
                                                } catch (e) {
                                                  ref.read(isLoading).state = false;
                                                } finally {
                                                  ref.read(isLoading).state = false;
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                'File',
                                                style: Constant()
                                                    .fontComfortaa
                                                    .copyWith(color: Colors.grey[400]),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
                      final sender = ref.read(UserProvider.provider)?.user;
                      final _pairingId = ref.read(pairingId).state;
                      final pairing = await ref
                          .read(ChatsMessageProvider.provider.notifier)
                          .getUserByID(_pairingId);
                      final messageContent = _messageController.text;

                      /// Save to temp Message for show in notification
                      _listMessages.add(messageContent);
                      log('List Message $_listMessages');

                      _messageController.clear();
                      await ref.read(ChatsMessageProvider.provider.notifier).sendMessage(
                          sender: sender,
                          pairing: pairing,
                          messageContent: messageContent,
                          listMessage: _listMessages);
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
