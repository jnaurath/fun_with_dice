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

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  Kniffel kniffel = new Kniffel();

  static const Map categories = {
    "3s": FontAwesomeIcons.diceThree,
    "4s": FontAwesomeIcons.diceFour,
    "smallStreet": FontAwesomeIcons.ellipsisV,
    "largeStreet": FontAwesomeIcons.road,
    "FullHouse": FontAwesomeIcons.houseUser,
    "Kniffel": FontAwesomeIcons.crown,
    "Chance": FontAwesomeIcons.questionCircle
  };

  String category = "";

  void dice() {
    setState(() {
      // int index = 0;
      // if (rounds > 0) {
      //   for (var dice in kniffe.dices) {
      //     // String before = dice.getValue();
      //     dice.dice();
      //     // print("dice (" +
      //     //     index.toString() +
      //     //     " / " +
      //     //     dice.getName() +
      //     //     ")! " +
      //     //     before +
      //     //     " --> " +
      //     //     dice.getValue());
      //     // index++;
      //   }
      //   rounds--;
      // } else {
      //   print("end of rounds");
      //   kniffel.calculateResult(category, value, dices);
      //   if (kniffel.gameFinished()) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ResultsPage()),
      //     );
      //   } else {
      //     rounds = 2;
      //     for (var dice in dices) {
      //       dice.setDiceState(false);
      //       dice.dice();
      //     }
      //     category = "";
      //     value = 0;
      //   }
      // }

      // print("Rounds left: " + (rounds).toString());
    });
  }

  void lockDice(index) {
    setState(() {
      kniffel.dices[index].changeDiceState();
      kniffel.allDicesLocked = kniffel.checkAllDicesLocked();
    });
  }

  void kniffelNextRound(bool forceNextRound) {
    setState(() {
      kniffel.nextRound(this.category, forceNextRound);
      this.category = "";
    });
  }

  Color setColor(String buttonCategory) {
    if (buttonCategory == this.category) {
      // selected
      return kActiveCardColor;
    } else if (kniffel.checkAlreadyCompleted(buttonCategory)) {
      // completed
      return kCompletedCardColor;
    } else {
      // not selected
      return kInactiveCardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kniffel'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: ReusableCard(
                  color: kInactiveCardColor,
                  cardChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sum',
                            style: kLabelTextStyle,
                          ),
                          Text(
                            kniffel.sum.toString(),
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  color: kInactiveCardColor,
                  cardChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Bonus',
                            style: kLabelTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                kniffel.bonus.toString(),
                                style: kNumberTextStyle,
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
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: ReusableCard(
                    onPress: () {},
                    cardChild: TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.all(5.0)),
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
                        Text(
                          (diceIndex + 1).toString(),
                          style: kNumberTextStyle,
                        ),
                        Text(
                          kniffel
                              .calculateResult((diceIndex + 1).toString())
                              .toString(),
                          style: kLabelTextStyle,
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
                            kniffelNextRound(true);
                          }
                          category = categories.keys.elementAt(categoriesIndex);
                        }
                      });
                    },
                    color: setColor(categories.keys.elementAt(categoriesIndex)),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          categories.values.elementAt(categoriesIndex),
                          // color: Colors.green,
                          size: 30.0,
                        ),
                        Text(
                          kniffel
                              .calculateResult(
                                  categories.keys.elementAt(categoriesIndex))
                              .toString(),
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          BottomButton(
            buttonTitle: (kniffel.rounds == 0 || kniffel.allDicesLocked)
                ? "Done"
                : "Dice (" + kniffel.rounds.toString() + ")",
            onTap: () {
              kniffelNextRound(false);
            },
          ),
        ],
      ),
    );
  }
}
