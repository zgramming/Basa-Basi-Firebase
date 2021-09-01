import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/network.dart';
import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../login/login_screen.dart';

import './widgets/account_menu_item.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: colorPallete.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Ink(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: InkWell(
                            child: Builder(
                              builder: (context) {
                                final user = ref.watch(UserProvider.provider)?.user;
                                Widget image;

                                if (user?.photoUrl.isEmpty ?? true) {
                                  image = CircleAvatar(
                                    backgroundColor: colorPallete.accentColor,
                                    radius: 60.0,
                                    child: const Icon(
                                      FeatherIcons.user,
                                      size: 40.0,
                                    ),
                                  );
                                } else {
                                  image = ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user!.photoUrl,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  );
                                }

                                return image;
                              },
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final user = ref.watch(UserProvider.provider)?.user;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  user?.name ?? '',
                                  style: Constant().fontMontserrat.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  user?.email ?? '',
                                  style: Constant().fontComfortaa.copyWith(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    style: Constant().fontComfortaa.copyWith(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w300),
                                    children: [
                                      const TextSpan(text: 'Terakhir login pada '),
                                      TextSpan(
                                        text:
                                            '${GlobalFunction.formatYMD(user?.loginAt ?? DateTime(1970, 10, 10), type: 3)} @${GlobalFunction.formatHM(user?.loginAt ?? DateTime(1970, 10, 10))}',
                                        style: Constant()
                                            .fontComfortaa
                                            .copyWith(fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                color: colorPallete.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountMenuItem(
                        onTap: () async {
                          showLicensePage(
                            context: context,
                            applicationIcon: Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 14.0),
                              padding: const EdgeInsets.all(14.0),
                              decoration: BoxDecoration(
                                color: colorPallete.primaryColor,
                                border: Border.all(
                                  color: colorPallete.monochromaticColor!,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                '${appConfig.urlImageAsset}/logo_white.png',
                                // fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        icon: FeatherIcons.codesandbox,
                        title: 'Lisensi',
                        subtitle: 'Daftar lisensi yang digunakan pada aplikasi ini',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                            builder: (context) => FractionallySizedBox(
                              heightFactor: .6,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 32.0,
                                    mainAxisSpacing: 32.0,
                                  ),
                                  itemCount: listSocialMedia.length,
                                  itemBuilder: (context, index) {
                                    final socialMedia = listSocialMedia[index];
                                    return InkWell(
                                      onTap: () async {
                                        try {
                                          final _url = socialMedia.url;
                                          await canLaunch(_url)
                                              ? await launch(_url)
                                              : throw 'Could not launch $_url';
                                        } catch (e) {
                                          GlobalFunction.showSnackBar(
                                            context,
                                            content: Text(e.toString()),
                                            snackBarType: SnackBarType.error,
                                          );
                                        }
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: colorPallete.primaryColor,
                                        ),
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(24.0),
                                                child: socialMedia.icon,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                socialMedia.name,
                                                style: Constant().fontMontserrat.copyWith(
                                                      fontSize: 14.0,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        icon: FeatherIcons.meh,
                        title: 'Tentang Developer',
                        subtitle:
                            'Punya pertanyaan yang mengganjal hatimu atau hanya ingin lebih dekat denganku ?',
                      ),
                      AccountMenuItem(
                        onTap: () async {
                          await ref.read(UserProvider.provider.notifier).signOut();
                          Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
                        },
                        icon: FeatherIcons.logOut,
                        title: 'Keluar',
                        subtitle: 'Jangan lupa untuk kembali lagi ya...',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
