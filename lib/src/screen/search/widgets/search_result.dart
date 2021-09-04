import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../provider/provider.dart';
import '../../../utils/utils.dart';
import '../../message/message_detail_screen.dart';

class SearchResult extends ConsumerStatefulWidget {
  const SearchResult({
    Key? key,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends ConsumerState<SearchResult> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _streamSearchUser = ref.watch(searchUserByEmail);
    return _streamSearchUser.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Text(
              'Kawan bicaranya ngga ketemu nich',
              style: Constant().fontMontserrat.copyWith(),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final pairing = users[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: pairing.photoUrl.isEmpty
                              ? Image.asset(
                                  '${appConfig.urlImageAsset}/logo_primary.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  pairing.photoUrl,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              pairing.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Constant().fontComfortaa.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                            ),
                            Expanded(
                              child: Center(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final userLogin = ref.read(UserProvider.provider)?.user;

                                    await ref
                                        .read(ChatsRecentProvider.provider.notifier)
                                        .resetUnreadMessageCount(
                                          userLogin: userLogin?.id ?? '',
                                          pairingId: pairing.id,
                                        );

                                    ///TODO Save pairing ID to global provider, then we can use on anywhere screen
                                    ref.read(pairingGlobal).state = pairing;
                                    Future.delayed(const Duration(milliseconds: 200), () {
                                      Navigator.of(context).pushNamed(
                                        MessageDetailScreen.routeNamed,
                                        arguments: pairing,
                                      );
                                    });
                                  },
                                  style:
                                      ElevatedButton.styleFrom(primary: colorPallete.accentColor),
                                  icon: const Icon(
                                    FeatherIcons.messageCircle,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Basa Basi'),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
