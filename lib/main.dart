import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vimigo/constant.dart';

import 'package:flutter_vimigo/view/home/home.dart';
import 'package:flutter_vimigo/view/onboard/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vimigo Assessment',
      theme: ThemeData(scaffoldBackgroundColor: kBackgroundColor),
      debugShowCheckedModeBanner: false,
      home: isViewed != 1 ? const Onboard() : const HomePage(),
    );
  }
}
