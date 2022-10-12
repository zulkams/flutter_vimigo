import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';

import 'package:flame/flame.dart'; // imports the Flame helper class
// imports the Position class

class DetailsPage extends StatefulWidget {
  final String userValue, phoneValue, checkInValue;

  const DetailsPage(
      {Key? key,
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

final game = GameWidget(game: CoinSprite());

class CoinSprite extends FlameGame {
  SpriteAnimationComponent animationComponent =
      SpriteAnimationComponent(size: Vector2(170 * 0.4, 171 * 0.4));

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    loadAnimations();

    add(animationComponent);
  }

  Future<void> loadAnimations() async {
    SpriteSheet spriteSheet = SpriteSheet(
        image: await images.load('animation.png'), srcSize: Vector2(170, 171));
    SpriteAnimation spriteAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 33);

    animationComponent.animation = spriteAnimation;
  }
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
        body: Center(
            child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                ))));
  }
}
