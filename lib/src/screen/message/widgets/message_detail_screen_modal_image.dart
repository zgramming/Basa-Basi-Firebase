import 'dart:developer';
import 'dart:io';

import 'package:basa_basi/src/provider/global/global_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:image_picker/image_picker.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageDetailScreenModalImage extends ConsumerStatefulWidget {
  final XFile file;
  const MessageDetailScreenModalImage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _MessageDetailScreenModalImageState createState() => _MessageDetailScreenModalImageState();
}

class _MessageDetailScreenModalImageState extends ConsumerState<MessageDetailScreenModalImage> {
  final _messageFocusNode = FocusNode();
  final _messageController = TextEditingController();

  final debouncer = Debouncer(milliseconds: 500);

  late final UserModel pairing;

  @override
  void initState() {
    pairing = ref.read(pairingGlobal).state!;
    SystemChrome.setEnabledSystemUIOverlays([]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateController<bool>>(isLoading, (value) {
      if (value.state) {
        showLoadingDialog(context);
      } else {
        Navigator.of(context).pop();
      }
    });
    final heightKeyboard = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () => _messageFocusNode.unfocus(),
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            SizedBox.expand(
              child: InteractiveViewer(
                panEnabled: false,
                boundaryMargin: const EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2,
                child: Image.file(
                  File(widget.file.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: KeyboardVisibilityBuilder(
                builder: (context, child, isKeyboardVisible) => Padding(
                  padding: EdgeInsets.only(bottom: isKeyboardVisible ? heightKeyboard - 30 : 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormFieldCustom(
                          focusNode: _messageFocusNode,
                          controller: _messageController,
                          disableOutlineBorder: false,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          padding: const EdgeInsets.all(16.0),
                          radius: 30,
                          hintText: 'Deskripsi gambar',
                          hintStyle: const TextStyle(fontSize: 11.0),
                        ),
                      ),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () async {
                          try {
                            ///* Start Loading
                            ref.read(isLoading).state = true;

                            ///* Save message to temporary messages provider
                            ref.read(tempListMessages.notifier).add("Mengirim gambar 📷");

                            final sender = ref.read(UserProvider.provider)?.user;

                            final messageContent = _messageController.text;
                            final messageType = (messageContent.trim().isEmpty)
                                ? MessageType.onlyImage
                                : MessageType.imageWithText;
                            _messageController.clear();

                            final filename = '${DateTime.now().millisecondsSinceEpoch}.png';
                            log('filename $filename');
                            final firebase_storage.Reference reference = firebase_storage
                                .FirebaseStorage.instance
                                .ref()
                                .child('images/')
                                .child(filename);
                            final metadata = firebase_storage.SettableMetadata(
                                contentType: 'image/jpeg',
                                customMetadata: {'picked-file-path': widget.file.path});

                            await reference.putFile(File(widget.file.path), metadata);

                            final urlFile = (await reference.getDownloadURL()).toString();
                            log('UrlFile $urlFile');

                            final tempMessages = ref.read(tempListMessages);
                            await ref.read(ChatsMessageProvider.provider.notifier).sendMessage(
                                  sender: sender,
                                  pairing: pairing,
                                  messageContent: messageContent,
                                  messageType: messageType,
                                  urlFile: urlFile,
                                  listMessage: tempMessages,
                                );

                            Navigator.of(context).pop();
                          } catch (e) {
                            ///* END Loading
                            log('error ${e.toString()}');
                            ref.read(isLoading).state = false;
                          } finally {
                            ///* END Loading
                            ref.read(isLoading).state = false;
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: colorPallete.success,
                          child: const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Icon(FeatherIcons.send),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                title: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30.0),
                  child: Row(
                    children: [
                      const Icon(FeatherIcons.arrowLeft),
                      const SizedBox(width: 5),
                      Ink(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorPallete.accentColor,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            pairing.photoUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
