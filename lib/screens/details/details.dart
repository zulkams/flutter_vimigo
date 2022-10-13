import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';

class DetailsPage extends StatefulWidget {
  // all passed data from previous screen
  final int idValue;
  final String userValue, phoneValue, checkInValue;

  const DetailsPage(
      {Key? key,
      required this.idValue,
      required this.userValue,
      required this.phoneValue,
      required this.checkInValue})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

@override
void initState() {
  initState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('VIMIGO CONTACTS'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: Stack(children: [
          Center(
              child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  elevation: 2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('ID'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Name'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Phone'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Check In'),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(':'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(':'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(':'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(':'),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // display received data from the previous screen
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.idValue
                                  .toString()), //int change to String
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.userValue),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.phoneValue),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.checkInValue),
                            )
                          ],
                        ),
                      ],
                    ),
                  ))),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.height * 0.12,
              // Animation based on given spritesheet
              child: SpriteAnimationWidget.asset(
                path: 'animation.png', //given spritesheet
                data: SpriteAnimationData.sequenced(
                  amount: 35, // total of sprites in the spritesheet
                  amountPerRow: 12, // total of sprites in a row
                  stepTime: 0.1, // steptime 0.1s
                  textureSize:
                      Vector2(170, 171), // size of every sprite (170px*171px)
                ),
                playing: true,
                anchor: Anchor.center,
              ),
            ),
          )
        ]));
  }
}
