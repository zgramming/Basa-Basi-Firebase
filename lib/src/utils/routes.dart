import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import '../network/network.dart';
import '../screen/introduction/introduction_screen.dart';
import '../screen/login/login_screen.dart';
import '../screen/message/message_archived_screen.dart';
import '../screen/message/message_detail_screen.dart';
import '../screen/search/search_screen.dart';
import '../screen/splash/splash_screen.dart';
import '../screen/welcome/welcome_screen.dart';

class MyRoute {
  static Route<dynamic>? configure(RouteSettings settings) {
    final route = RouteAnimation();
    switch (settings.name) {
      case SplashScreen.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) => const SplashScreen(),
        );
      case Introduction.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) => const Introduction(),
        );
      case LoginScreen.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) => const LoginScreen(),
        );
      case WelcomeScreen.routeNamed:
        return route.fadeTransition(
          screen: (ctx, animation, secondaryAnimation) => const WelcomeScreen(),
        );
      case MessageDetailScreen.routeNamed:
        final pairing = settings.arguments as UserModel?;
        return route.slideTransition(
          slidePosition: SlidePosition.fromRight,
          screen: (ctx, animation, secondaryAnimation) => MessageDetailScreen(pairing: pairing),
        );
      case SearchScreen.routeNamed:
        return route.slideTransition(
          screen: (ctx, animation, secondaryAnimation) => const SearchScreen(),
        );
      case MessageArchivedScreen.routeNamed:
        return route.slideTransition(
          screen: (ctx, animation, secondaryAnimation) => const MessageArchivedScreen(),
        );
      default:
    }
  }
}
