import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:global_template/global_template.dart';

class SocialMediaModel extends Equatable {
  final String name;
  final Widget icon;
  final String url;

  const SocialMediaModel({
    this.name = '',
    this.icon = const Icon(Icons.home),
    this.url = '',
  });

  @override
  List<Object> get props => [name, icon, url];

  @override
  bool get stringify => true;

  SocialMediaModel copyWith({
    String? name,
    Widget? icon,
    String? url,
  }) {
    return SocialMediaModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      url: url ?? this.url,
    );
  }
}

final listSocialMedia = [
  const SocialMediaModel(
    name: 'Facebook',
    icon: Icon(FeatherIcons.facebook, color: Colors.white, size: 40.0),
    url: 'https://www.facebook.com/zeffry.reynando',
  ),
  const SocialMediaModel(
    name: 'LinkedIn',
    icon: Icon(FeatherIcons.linkedin, color: Colors.white, size: 40.0),
    url: 'https://www.linkedin.com/in/zeffry-reynando/',
  ),
  const SocialMediaModel(
      name: 'Instagram',
      icon: Icon(FeatherIcons.instagram, color: Colors.white, size: 40.0),
      url: 'https://www.instagram.com/zeffry_reynando/'),
  const SocialMediaModel(
    name: 'Github',
    icon: Icon(FeatherIcons.github, color: Colors.white, size: 40.0),
    url: 'https://github.com/zgramming/',
  ),
  const SocialMediaModel(
    name: 'Website',
    icon: Icon(FeatherIcons.globe, color: Colors.white, size: 40.0),
    url: 'http://zeffry.dev/',
  ),
  SocialMediaModel(
    name: 'Google Playstore',
    icon: FittedBox(
      child: Text(
        GlobalFunction.getFirstCharacter('Google Playstore', limitTo: 2),
        style: const TextStyle(color: Colors.white),
      ),
    ),
    url: 'https://play.google.com/store/apps/dev?id=4702576898173669566',
  ),
];
