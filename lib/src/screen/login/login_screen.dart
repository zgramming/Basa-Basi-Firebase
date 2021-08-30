import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../provider/provider.dart';
import '../../utils/utils.dart';

import '../welcome/welcome_screen.dart';

class LoginScreen extends ConsumerWidget {
  static const routeNamed = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<StateController<bool>>(isLoading, (loading) {
      if (loading.state) {
        showLoadingDialog(context);
        return;
      }
      Navigator.of(context).pop();
      return;
    });
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                '${appConfig.urlImageAsset}/logo_primary.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Login aplikasi lebih mudah hanya dengan menggunakan akun google kamu',
                      textAlign: TextAlign.center,
                      style: Constant().fontComfortaa.copyWith(fontSize: 18.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            log('message');
                            try {
                              ref.read(isLoading).state = true;
                              final result =
                                  await ref.read(UserProvider.provider.notifier).signIn();
                              log('result $result');
                              if (result) {
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(WelcomeScreen.routeNamed);
                                });
                                return;
                              }
                            } catch (e) {
                              log(e.toString());
                            } finally {
                              log('Finally Done');
                              ref.read(isLoading).state = false;
                            }
                          },
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(24.0)),
                          child: const Text(
                            'Sign in with Google',
                          ),
                        );
                      },
                    ),
                  ),
                ),
                CopyRightVersion(
                  backgroundColor: colorPallete.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
