import 'package:flutter/material.dart';
import 'package:flutter_vimigo/constant.dart';
import 'package:flutter_vimigo/view/home/home.dart';
import 'package:flutter_vimigo/view/onboard/onboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final onboardController = PageController();

  bool _isFinished = false;

  @override
  void dispose() {
    onboardController.dispose();

    super.dispose();
  }

  _storeOnBoardInfo() async {
    int isViewed = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      PageView.builder(
        itemCount: screens.length,
        controller: onboardController,
        onPageChanged: (value) {
          if (value == 2) {
            setState(() {
              _isFinished = true;
            });
          } else {
            setState(() {
              _isFinished = false;
            });
          }
        },
        itemBuilder: (context, index) {
          return Container(
              color: screens[index].background,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  screens[index].title,
                  style: const TextStyle(fontSize: 18),
                ),
              )));
        },
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 45),
            child: SmoothPageIndicator(
              controller: onboardController,
              count: 3,
              effect: const ExpandingDotsEffect(dotHeight: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width / 3.5,
                      70,
                    ),
                  ),
                  onPressed: () => _isFinished
                      ? onboardController.jumpToPage(0)
                      : onboardController.jumpToPage(2),
                  child: Text(
                    _isFinished ? 'First' : 'Skip',
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    textStyle: const TextStyle(fontSize: 20),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width / 3.5,
                      70,
                    ),
                  ),
                  onPressed: () async {
                    _isFinished
                        ? _storeOnBoardInfo().then((value) =>
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                                (Route<dynamic> route) => false))
                        : onboardController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                  },
                  child: Text(
                    _isFinished ? 'Enter' : 'Next',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]));
  }
}
