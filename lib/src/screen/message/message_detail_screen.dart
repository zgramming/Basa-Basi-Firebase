import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../network/network.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/message-detail-screen';
  final UserModel? pairing;
  const MessageDetailScreen({
    Key? key,
    required this.pairing,
  }) : super(key: key);

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen> {
  late final String channelMessage;

  final _messageFocusNode = FocusNode();
  final _messageController = TextEditingController();

  final debouncer = Debouncer(milliseconds: 500);
  final _messageReplyId = '';

  late final ScrollController _scrollController;

  // final FlutterSoundPlayer? _voiceMessagePlayer = FlutterSoundPlayer(logLevel: Level.debug);

  // final FlutterSoundRecorder? _voiceMessageRecorder = FlutterSoundRecorder();

  // bool _vmPlayerIsInited = false;

  // bool _vmRecorderIsInited = false;
  // bool _vmRecorderIsPlaying = false;

  bool _showEmojiPicker = false;
  bool _textFieldIsEmpty = true;

  @override
  void initState() {
    final userLogin = ref.read(UserProvider.provider);
    channelMessage = getConversationID(
      senderId: userLogin?.id ?? '',
      pairingId: widget.pairing?.id ?? '',
    );

    _scrollController = ScrollController()
      ..addListener(() {
        log('${_scrollController.offset}');
      });
    super.initState();
  }
  //   _voiceMessagePlayer?.openAudioSession().then((value) {
  //     _vmPlayerIsInited = true;
  //   });

  //   _voiceMessageRecorder?.openAudioSession().then((value) {
  //     _vmRecorderIsInited = true;
  //   });
  // }

  // @override
  // void dispose() {
  //   _voiceMessageRecorder?.closeAudioSession();
  //   _voiceMessagePlayer?.closeAudioSession();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmojiPicker) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
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
                          widget.pairing?.photoUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft, child: Text(widget.pairing?.name ?? '')),
                    Consumer(
                      builder: (context, ref, child) {
                        final _streamTyping =
                            ref.watch(listenRecentMessage(widget.pairing?.id ?? ''));
                        return _streamTyping.when(
                          data: (message) => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            switchInCurve: Curves.bounceIn,
                            switchOutCurve: Curves.bounceOut,
                            child: (message.isTyping ?? false)
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
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => Center(
                            child: Text(error.toString()),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [const PopupMenuItem(child: Text('Hapus chat'))],
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final senderId = ref.watch(UserProvider.provider)?.id;
                  final channelMessage = getConversationID(
                    senderId: senderId ?? '',
                    pairingId: widget.pairing?.id ?? '',
                  );
                  final _streamMessage = ref.watch(getMessage(channelMessage));
                  return _streamMessage.when(
                    data: (val) {
                      final messages = ref.watch(messageById(channelMessage)).state;
                      return SingleChildScrollView(
                        controller: _scrollController,
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: messages.entries.map(
                              (map) {
                                final date = map.key;
                                final listMessage = map.value;
                                return Column(
                                  children: [
                                    Card(
                                      color: colorPallete.monochromaticColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          compareDateMessage(date),
                                          style: Constant()
                                              .fontMontserrat
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemCount: listMessage.length,
                                      itemBuilder: (context, index) {
                                        final message = listMessage[index];
                                        return Align(
                                          alignment: message.senderId == senderId
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Card(
                                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(14.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: message.senderId == senderId
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: [
                                                  Text(message.messageContent),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    GlobalFunction.formatHM(
                                                      message.messageDate ?? DateTime.now(),
                                                    ),
                                                    style: Constant().fontMontserrat.copyWith(
                                                          fontWeight: FontWeight.w100,
                                                          fontSize: 10.0,
                                                          color: Colors.grey[400],
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20.0),
                          onChanged: (value) {
                            if (value.isNotEmpty && _textFieldIsEmpty) {
                              setState(() => _textFieldIsEmpty = false);
                            }

                            if (value.isEmpty) {
                              setState(() => _textFieldIsEmpty = true);
                            }
                            debouncer.run(() async {
                              try {
                                final userLogin = ref.read(UserProvider.provider);

                                await ref
                                    .read(ChatsRecentProvider.provider.notifier)
                                    .updateTypingStatus(
                                      senderId: userLogin?.id ?? '',
                                      pairingId: widget.pairing?.id ?? '',
                                      channelMessage: channelMessage,
                                      isTyping: true,
                                    );

                                Future.delayed(const Duration(milliseconds: 300), () async {
                                  await ref
                                      .read(ChatsRecentProvider.provider.notifier)
                                      .updateTypingStatus(
                                        senderId: userLogin?.id ?? '',
                                        pairingId: widget.pairing?.id ?? '',
                                        channelMessage: channelMessage,
                                        isTyping: false,
                                      );
                                });
                              } catch (e) {
                                log(e.toString());
                              }
                            });
                          },
                          onTap: () {
                            if (_messageFocusNode.canRequestFocus) {
                              setState(() => _showEmojiPicker = false);
                            }
                          },
                          prefixIcon: IconButton(
                            onPressed: () {
                              _showEmojiPicker = true;

                              _messageFocusNode.unfocus();
                              _messageFocusNode.canRequestFocus = false;
                              Future.delayed(const Duration(milliseconds: 100), () {
                                _messageFocusNode.canRequestFocus = true;
                              });
                              setState(() {});
                            },
                            icon: const Icon(FeatherIcons.smile),
                          ),
                          suffixIcon: Wrap(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: !_textFieldIsEmpty
                                    ? const SizedBox()
                                    : IconButton(
                                        onPressed: () {
                                          _messageFocusNode.unfocus();
                                          _messageFocusNode.canRequestFocus = false;
                                          Future.delayed(const Duration(milliseconds: 100), () {
                                            _messageFocusNode.canRequestFocus = true;
                                          });
                                        },
                                        icon: const Icon(FeatherIcons.camera),
                                      ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _messageFocusNode.unfocus();
                                  _messageFocusNode.canRequestFocus = false;
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    _messageFocusNode.canRequestFocus = true;
                                  });
                                },
                                icon: const Icon(FeatherIcons.paperclip),
                              ),
                            ],
                          ),
                          disableOutlineBorder: false,
                          radius: 60.0,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Consumer(
                    builder: (context, ref, child) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _textFieldIsEmpty
                          ? GestureDetector(
                              onTapDown: (_) async {
                                log('on tap down');
                                // _messageFocusNode.unfocus();
                                // _messageFocusNode.canRequestFocus = false;
                                // try {
                                //   final requestMicPermission =
                                //       await Permission.microphone.request();
                                //   if (requestMicPermission != PermissionStatus.granted) {
                                //     throw RecordingPermissionException(
                                //       'Mohon berikan izin menggunakan microphone',
                                //     );
                                //   }
                                //   final tempDir = (await getApplicationDocumentsDirectory()).path;
                                //   final userLogin = ref.read(UserProvider.provider);
                                //   await _voiceMessageRecorder?.startRecorder(
                                //     toFile: '$tempDir/voice_chat.mp3',
                                //     // audioSource:
                                //   );
                                //   await Future.delayed(const Duration(seconds: 2), () async {
                                //     final result = await _voiceMessageRecorder?.stopRecorder();
                                //     log('result $result');
                                //   });
                                //   log('request mic $requestMicPermission');
                                // } catch (e) {
                                //   var message = e.toString();
                                //   if (e is RecordingPermissionException) {
                                //     message = e.message;
                                //   }

                                //   GlobalFunction.showSnackBar(
                                //     context,
                                //     content: Text(message.toString()),
                                //     snackBarType: SnackBarType.error,
                                //   );
                                // }
                              },
                              onTapUp: (_) {
                                log('on tap up');
                              },
                              key: UniqueKey(),
                              child: Ink(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: colorPallete.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(
                                      FeatherIcons.mic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              key: UniqueKey(),
                              borderRadius: BorderRadius.circular(60.0),
                              onTap: () async {
                                try {
                                  if (_messageController.text.trim().isEmpty) {
                                    throw Exception('Pesan tidak boleh kosong');
                                  }
                                  ref.read(isLoading).state = true;
                                  final user = ref.read(UserProvider.provider);
                                  // log('sender ${senderId?.id}');
                                  final data = <String, dynamic>{
                                    'senderId': user?.id,
                                    'pairingId': widget.pairing?.id,
                                    'messageContent': _messageController.text,
                                    'messageType': MessageType.onlyText,
                                    'messageReplyId': _messageReplyId,
                                  };
                                  _messageController.clear();
                                  setState(() => _textFieldIsEmpty = true);
                                  await ref.read(postMessage(data).future);
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
                                width: 50.0,
                                height: 50.0,
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
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Visibility(
              visible: _showEmojiPicker,
              child: Flexible(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) => _messageController
                    ..text += emoji.emoji
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: _messageController.text.length),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
