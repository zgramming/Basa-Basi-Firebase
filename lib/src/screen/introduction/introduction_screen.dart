import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../login/login_screen.dart';

class Introduction extends ConsumerWidget {
  static const routeNamed = '/introduction';
  const Introduction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntroductionScreen(
      globalBackgroundColor: colorPallete.primaryColor,
      done: ElevatedButton(
        onPressed: () async {
          await ref.read(SessionProvider.provider.notifier).setOnboardingSession(value: true);

          await Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
          });
        },
        child: Text(
          'mulai',
          style: Constant().fontMontserrat.copyWith(color: Colors.white),
        ),
      ),
      dotsDecorator: DotsDecorator(activeColor: colorPallete.accentColor!, color: Colors.white),
      showNextButton: false,
      // next: ElevatedButton(onPressed: () {}, child: Text('Lanjut')),
      onChange: (value) => log('onchange introduction screen $value'),
      onDone: () => log('Ondone introduction screen'),
      onSkip: () => log('onskip introduction screen'),
      pages: [
        PageViewModel(
          image: Center(
            child: Image.asset(
              Constant().onboardingImage1,
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
          ),
          title: 'Chatting bersama teman, sahabat, pacar, orang tua',
          body: '',
          decoration: PageDecoration(
              titleTextStyle:
                  Constant().fontComfortaa.copyWith(color: Colors.white, fontSize: 24.0)),
        ),
        PageViewModel(
          image: Center(
            child: Image.asset(
              Constant().onboardingImage2,
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
          ),
          title: 'Meriahkan chatting dengan menggungah gambar & emoji',
          body: '',
          decoration: PageDecoration(
              titleTextStyle:
                  Constant().fontComfortaa.copyWith(color: Colors.white, fontSize: 24.0)),
        ),
        PageViewModel(
          image: Center(
            child: Image.asset(
              Constant().onboardingImage3,
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
          ),
          title: 'Ayo mulai jalin komunikasimu sekarang',
          body: '',
          decoration: PageDecoration(
              titleTextStyle:
                  Constant().fontComfortaa.copyWith(color: Colors.white, fontSize: 24.0)),
        ),
      ],
    );
  }
}
