import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

import '../../search/search_screen.dart';

class WelcomeScreenFAB extends StatelessWidget {
  const WelcomeScreenFAB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).pushNamed(SearchScreen.routeNamed);
        },
        borderRadius: BorderRadius.circular(60.0),
        child: Container(
          height: 55.0,
          width: 55.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorPallete.accentColor,
          ),
          child: const FittedBox(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                FeatherIcons.messageSquare,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
