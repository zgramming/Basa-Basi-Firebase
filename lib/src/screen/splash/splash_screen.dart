import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';

import '../introduction/introduction_screen.dart';
import '../login/login_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeNamed = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPallete.primaryColor,
      body: Consumer(
        builder: (context, ref, child) {
          final _readSession = ref.watch(initializeApplication);
          return _readSession.when(
            data: (value) {
              if (!value.alreadyOnboarding) {
                return const Introduction();
              } else if (value.user == null) {
                return const LoginScreen();
              } else {
                return const WelcomeScreen();
              }
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (error, stackTrace) {
              log('error splash screen $stackTrace');
              return Center(child: Text(error.toString()));
            },
          );
        },
      ),
    );
  }
}
