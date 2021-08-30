import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../utils/utils.dart';

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const AccountMenuItem({
    Key? key,
    this.icon = FeatherIcons.home,
    this.title = 'Title',
    this.subtitle = 'Subtitle',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(12.0),
      leading: Icon(
        icon,
        color: Colors.white,
        size: 40.0,
      ),
      title: Text(
        title,
        style: Constant().fontMontserrat.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 10.0),
          Divider(
            thickness: 1,
            color: Colors.white.withOpacity(.5),
          )
        ],
      ),
    );
  }
}
