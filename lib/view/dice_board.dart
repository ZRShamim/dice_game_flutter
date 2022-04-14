import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DiceBoard extends StatelessWidget {
  DiceBoard({Key? key}) : super(key: key);

  final dice = 0.obs; //initial dice value
  final diceAnimation = false.obs;
  final totalPointsP1 = 0.obs;
  final totalPointsP2 = 0.obs;
  final isP1Active = true.obs;
  final isP2Active = false.obs;
  
  final tempPoint = 0.obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: pi,
              // p2 Tab
              child: PlayerTab(
                dice: dice,
                diceAnimation: diceAnimation,
                isP1Active: isP1Active,
                tempPoint: tempPoint,
                totalPoints: totalPointsP2,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Dice(dice: dice, diceAnimation: diceAnimation),
            const SizedBox(
              height: 20,
            ),
            // P1 Tab
            PlayerTab(
              dice: dice,
              diceAnimation: diceAnimation,
              isP1Active: isP1Active,
              tempPoint: tempPoint,
              totalPoints: totalPointsP2,
            ),
          ],
        ),
      ),
    );
  }
}

class Dice extends StatelessWidget {
  const Dice({
    Key? key,
    required this.dice,
    required this.diceAnimation,
  }) : super(key: key);

  final RxInt dice;
  final RxBool diceAnimation;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return dice.value == 0
          ? Lottie.asset('assets/lottie/dice-animation.json',
              animate: diceAnimation.value, height: 150)
          : Image.asset(
              'assets/images/dice-${dice.value}.png',
              height: 150,
            );
    });
  }
}

class PlayerTab extends StatelessWidget {
  const PlayerTab({
    Key? key,
    required this.isP1Active,
    required this.diceAnimation,
    required this.dice,
    required this.tempPoint,
    required this.totalPoints,
  }) : super(key: key);
  final RxBool isP1Active;
  final RxBool diceAnimation;
  final RxInt dice;
  final RxInt tempPoint;
  final RxInt totalPoints;

  Future<int> rollDice() async {
    dice.value = 0;
    return Future.delayed(
        const Duration(seconds: 5), () => Random().nextInt(6) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(
          () => ElevatedButton(
            onPressed: !isP1Active.value
                ? null
                : () async {
                    diceAnimation.value = true;
                    dice.value = await rollDice();
                    if (dice.value == 1) {
                      tempPoint.value = 0;
                      isP1Active.value = false;
                    } else {
                      tempPoint.value += dice.value;
                    }
                  }, //generating random dice value
            child: const Text('Roll dice'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Obx(
          () => Text(
            totalPoints.value.toString(),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Obx(
          () => ElevatedButton(
            onPressed: !isP1Active.value
                ? null
                : () {
                    isP1Active.value = false;
                    totalPoints.value += tempPoint.value;
                    tempPoint.value = 0;
                  },
            child: const Text('Hold'),
          ),
        )
      ],
    );
  }
}
