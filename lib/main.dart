import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import './src/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  colorPallete.configuration(
    primaryColor: const Color(0xFF0A4969),
    accentColor: const Color(0xFF00C6B2),
    monochromaticColor: const Color(0xFF3A5984),
    success: const Color(0xFF3D6C31),
    warning: const Color(0xFFF9F871),
    info: const Color(0xFF983E4C),
    error: const Color(0xFF00BBFF),
  );
  runApp(ProviderScope(child: MyApp()));
}
