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
  void initState() {
    ref.read(initializeApplication.future).then((_) {
      final alreadyOnboarding = ref.read(SessionProvider.provider).isAlreadyOnboarding;
      final alreadySignIn = ref.read(UserProvider.provider);

      if (!alreadyOnboarding) {
        Navigator.of(context).pushReplacementNamed(Introduction.routeNamed);
      } else if (alreadySignIn == null) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeNamed);
      } else {
        Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPallete.primaryColor,
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
