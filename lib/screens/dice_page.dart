import 'package:flutter/foundation.dart';
import 'package:fun_with_dice/classes/dice.dart';
import 'package:fun_with_dice/classes/kniffel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_with_dice/components/icon_content.dart';
import 'package:fun_with_dice/components/reusable_card.dart';
import 'package:fun_with_dice/constants.dart';
import 'package:fun_with_dice/screens/results_page.dart';
import 'package:fun_with_dice/components/bottom_button.dart';
import 'package:fun_with_dice/components/round_icon_button.dart';
import 'package:confetti/confetti.dart';

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  @override
  void dispose() {
    kniffel.confettiController.dispose();
  }

  @override
  void initState() {
    kniffel.confettiController.addListener(() {
      setState(() {
        kniffel.isConfettiPlaying =
            kniffel.confettiController.state == ConfettiControllerState.playing;
      });
    });
  }

  Kniffel kniffel = new Kniffel();

  static const Map categories = {
    "3s": Icon(
      FontAwesomeIcons.diceThree,
      color: colorPalette5,
      size: 30.0,
    ),
    "4s": Icon(
      FontAwesomeIcons.diceFour,
      color: colorPalette5,
      size: 30.0,
    ),
    "smallStreet": Icon(
      FontAwesomeIcons.road,
      color: colorPalette5,
      size: 30.0,
    ),
    "largeStreet": Icon(
      FontAwesomeIcons.road,
      color: colorPalette5,
      size: 30.0,
    ),
    "FullHouse": Icon(
      FontAwesomeIcons.houseUser,
      color: colorPalette5,
      size: 30.0,
    ),
    "Kniffel": Icon(
      FontAwesomeIcons.crown,
      color: colorPalette5,
      size: 30.0,
    ),
    "Chance": Icon(
      FontAwesomeIcons.clover,
      color: colorPalette5,
      size: 30.0,
    ),
  };

  String category = "";
  String selectedCategory = "";

  // String getPredictedResult(String category) {
  //   print("function getPredictedResult: " + category);
  //   setState(() {
  //     return "15";
  //     if (!kniffel.checkAlreadyCompleted(category)) {
  //       print("not completed: " + kniffel.calculateResult(category).toString());
  //       return kniffel.calculateResult(category).toString();
  //     } else {
  //       print("completed: " + kniffel.getResult(category).toString());
  //       return kniffel.getResult(category).toString();
  //     }
  //   });
  // }

  disableButton() {
    if (kniffel.rounds == 0 || kniffel.allDicesLocked) {
      if (this.category == "") {
        return true;
      }
    }
    return false;
  }

  void lockDice(index) {
    setState(() {
      kniffel.dices[index].changeDiceState();
      kniffel.allDicesLocked = kniffel.checkAllDicesLocked();
    });
  }

  String getButtonTitle() {
    if (kniffel.rounds == 0 || kniffel.allDicesLocked) {
      return "Done";
    } else if (kniffel.gameFinished()) {
      return "New Game";
    } else {
      return "Dice"; // (" + kniffel.rounds.toString() + ")";
    }
  }

  void kniffelNextRound(bool forceNextRound) {
    setState(() {
      // else {
      //   confettiController.play();
      // }

      this.selectedCategory = this.category;
      if (kniffel.endNextRound) {
        this.selectedCategory = "";
      }
      kniffel.nextRound(this.category, forceNextRound);
      this.category = "";
    });
  }

  Color setColor(String buttonCategory) {
    if (buttonCategory == this.selectedCategory) {
      // previous selected
      return colorPalette1;
    } else if (buttonCategory == this.category) {
      // selected
      return colorPalette4;
    } else if (kniffel.checkAlreadyCompleted(buttonCategory) ||
        buttonCategory == this.selectedCategory) {
      // completed
      return colorPalette1;
    } else {
      // not selected
      return colorPalette3;
    }
  }

  Color setColorNumbers(String buttonCategory) {
    if (buttonCategory == this.selectedCategory) {
      // previous selected
      return colorPalette1;
    } else if (buttonCategory == this.category) {
      // selected
      return colorPalette5;
    } else if (kniffel.checkAlreadyCompleted(buttonCategory) ||
        buttonCategory == this.selectedCategory) {
      // completed
      return colorPalette2;
    } else {
      // not selected
      return colorPalette4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Scaffold(
        appBar: AppBar(
          title: Text('Kniffel'),
          backgroundColor: colorPalette4,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: ReusableCard(
                    color: colorPalette3,
                    cardChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Sum',
                              style: labelTextStyle,
                            ),
                            Text(
                              kniffel.sum.toString(),
                              style: numberTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: colorPalette3,
                    cardChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Bonus',
                              style: labelTextStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                  kniffel.bonus.toString(),
                                  style: numberTextStyle,
                                ),
                                Text(
                                  kniffel.bonusDiff.toString(),
                                  style: kniffel.bonusDiff >= 0
                                      ? kLabelBonusPositiveTextStyle
                                      : kLabelBonusNegativeTextStyle,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: ReusableCard(
                      onPress: () {},
                      cardChild: TextButton(
                        style:
                            TextButton.styleFrom(padding: EdgeInsets.all(5.0)),
                        child: Image.asset(
                          'images/dice' +
                              kniffel.dices[index].getValue() +
                              '.png',
                          color: kniffel.dices[index].getDiceState()
                              ? lockedDiceColor
                              : unlockedDiceColor,
                        ),
                        onPressed: () {
                          lockDice(index);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Numbers
            Expanded(
              child: Row(
                children: List.generate(6, (diceIndex) {
                  return Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          if (!kniffel.checkAlreadyCompleted(
                              (diceIndex + 1).toString())) {
                            if (category == (diceIndex + 1).toString()) {
                              print("forceNextRound");
                              this.selectedCategory =
                                  (diceIndex + 1).toString();
                              kniffelNextRound(true);
                            }
                            category = (diceIndex + 1).toString();
                          }
                        });
                      },
                      color: setColor((diceIndex + 1).toString()),
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text((diceIndex + 1).toString(),
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: colorPalette5,
                              )
                              // color: setColorNumbers(
                              //     (diceIndex + 1).toString())),
                              ),
                          Text(
                            !kniffel.checkAlreadyCompleted(
                                    (diceIndex + 1).toString())
                                ? kniffel
                                    .calculateResult((diceIndex + 1).toString())
                                    .toString()
                                : kniffel
                                    .getResult((diceIndex + 1).toString())
                                    .toString(),
                            style: labelTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            // specials
            Expanded(
              child: Row(
                children: List.generate(categories.length, (categoriesIndex) {
                  return Expanded(
                    child: ReusableCard(
                      onPress: () {
                        setState(() {
                          if (!kniffel.checkAlreadyCompleted(
                              categories.keys.elementAt(categoriesIndex))) {
                            if (category ==
                                categories.keys.elementAt(categoriesIndex)) {
                              print("forceNextRound");
                              this.selectedCategory =
                                  categories.keys.elementAt(categoriesIndex);
                              kniffelNextRound(true);
                            }
                            category =
                                categories.keys.elementAt(categoriesIndex);
                          }
                        });
                      },
                      color:
                          setColor(categories.keys.elementAt(categoriesIndex)),
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          categories.values.elementAt(categoriesIndex),
                          Text(
                              !kniffel.checkAlreadyCompleted(categories.keys
                                      .elementAt(categoriesIndex))
                                  ? kniffel
                                      .calculateResult(categories.keys
                                          .elementAt(categoriesIndex))
                                      .toString()
                                  : kniffel
                                      .getResult(categories.keys
                                          .elementAt(categoriesIndex))
                                      .toString(),
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: colorPalette5,
                              ) // color: setColorNumbers(categories.keys
                              //     .elementAt(categoriesIndex))),
                              ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            BottomButton(
              buttonTitle: getButtonTitle(),
              onTap: () {
                kniffelNextRound(false);
              },
              disabled: disableButton(),
              rounds: kniffel.rounds,
            ),
          ],
        ),
      ),
      ConfettiWidget(
        confettiController: kniffel.confettiController,
        shouldLoop: false,
        numberOfParticles: 20,
        blastDirectionality: BlastDirectionality.explosive,
      )
    ]);
  }
}
