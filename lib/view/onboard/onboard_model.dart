import 'package:flutter/material.dart';
import 'package:flutter_vimigo/constant.dart';

class OnboardModel {
  String title;
  Color? background;

  OnboardModel({
    required this.title,
    required this.background,
  });
}

List<OnboardModel> screens = <OnboardModel>[
  OnboardModel(
      title: "Create new user contact by tapping on the orange button!",
      background: kPrimaryColor),
  OnboardModel(
      title: "Search for users' contact by entering their name as keyword!",
      background: onboardBackground2),
  OnboardModel(
      title: "Sort their contact information by tapping on the sort icon!",
      background: onboardBackground3),
];
