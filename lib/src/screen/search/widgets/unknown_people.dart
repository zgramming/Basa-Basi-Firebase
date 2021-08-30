import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../../utils/utils.dart';

class UnknownPeopleTabbar extends StatefulWidget {
  const UnknownPeopleTabbar({
    Key? key,
  }) : super(key: key);

  @override
  _UnknownPeopleTabbarState createState() => _UnknownPeopleTabbarState();
}

class _UnknownPeopleTabbarState extends State<UnknownPeopleTabbar>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Text('belum kenal');
  }

  @override
  bool get wantKeepAlive => true;
}

class KnownPeopleTabbar extends StatefulWidget {
  const KnownPeopleTabbar({
    Key? key,
  }) : super(key: key);

  @override
  _KnownPeopleTabbarState createState() => _KnownPeopleTabbarState();
}

class _KnownPeopleTabbarState extends State<KnownPeopleTabbar> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: 100,
        itemBuilder: (context, index) => Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    '${appConfig.urlImageAsset}/logo_primary.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Zeffry Reynando Fernando Reberto Carlos',
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(primary: colorPallete.accentColor),
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
