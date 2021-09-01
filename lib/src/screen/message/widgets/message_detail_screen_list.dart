import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../network/network.dart';
import '../../../provider/provider.dart';
import '../../../utils/utils.dart';

class MessageDetailScreenList extends StatelessWidget {
  const MessageDetailScreenList({
    Key? key,
    required this.listMessage,
  }) : super(key: key);

  final List<ChatsMessageModel> listMessage;

  Widget showMessage(ChatsMessageModel model, BuildContext context) {
    Widget widget = const SizedBox();
    switch (model.messageType) {
      case MessageType.onlyText:
        widget = Text(
          model.messageContent,
          style: Constant().fontComfortaa.copyWith(fontSize: 12.0),
        );
        break;
      case MessageType.onlyImage:
        widget = GestureDetector(
          onTap: () async =>
              GlobalFunction.showDetailSingleImage(context, url: model.urlFile ?? ''),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sizes.width(context) / 2.5),
            child: CachedNetworkImage(imageUrl: model.urlFile ?? ''),
          ),
        );
        break;
      case MessageType.imageWithText:
        widget = GestureDetector(
          onTap: () async =>
              GlobalFunction.showDetailSingleImage(context, url: model.urlFile ?? ''),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(),
                child: CachedNetworkImage(
                  imageUrl: model.urlFile ?? '',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(model.messageContent),
            ],
          ),
        );
        break;
      case MessageType.voice:
        break;
      case MessageType.file:
        break;
      default:
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final senderId = ref.watch(UserProvider.provider)?.user?.id ?? '';
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          reverse: true,
          shrinkWrap: true,
          itemCount: listMessage.length,
          itemBuilder: (context, index) {
            final message = listMessage[index];
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: sizes.width(context) / 2),
              child: Align(
                alignment:
                    message.senderId == senderId ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  margin: EdgeInsets.only(
                    top: 6.0,
                    left: message.senderId == senderId ? 40.0 : 0.0,
                    right: message.senderId == senderId ? 0.0 : 40.0,
                  ),
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
                        showMessage(message, context),
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
              ),
            );
          },
        );
      },
    );
  }
}
