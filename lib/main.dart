import 'package:flutter/material.dart';
import 'package:flutter_vimigo/constant.dart';
import 'package:flutter_vimigo/screens/home/home.dart';
import 'package:flutter_vimigo/screens/onboard/onboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;

void main() async {
  // ensure everything is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // check SharedPreference for onboarding screen
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
      // if already viewed (1), go to HomeScreen
      home: isViewed != 1 ? const Onboard() : const HomePage(),
    );
  }
}
