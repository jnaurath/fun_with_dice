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

enum Gender {
  male,
  female,
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  Kniffel kniffel = new Kniffel();
  List<Dice> dices = [
    new Dice("no.1"),
    new Dice("no.2"),
    new Dice("no.3"),
    new Dice("no.4"),
    new Dice("no.5"),
  ];

  static const List<String> categories = [
    "3s",
    "4s",
    "smallStreet",
    "largeStreet",
    "FullHouse",
    "Kniffel",
    "Chance"
  ];

  String category = "";
  int value = 0;
  bool allDicesLocked = false;

  void dice() {
    setState(() {
      // int index = 0;
      if (rounds > 0) {
        for (var dice in dices) {
          // String before = dice.getValue();
          dice.dice();
          // print("dice (" +
          //     index.toString() +
          //     " / " +
          //     dice.getName() +
          //     ")! " +
          //     before +
          //     " --> " +
          //     dice.getValue());
          // index++;
        }
        rounds--;
      } else {
        print("end of rounds");
        kniffel.calculateResult(category, value, dices);
        if (kniffel.gameFinished()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultsPage()),
          );
        } else {
          rounds = 2;
          for (var dice in dices) {
            dice.setDiceState(false);
            dice.dice();
          }
          category = "";
          value = 0;
        }
      }

      print("Rounds left: " + (rounds).toString());
    });
  }

  void lockDice(index) {
    setState(() {
      dices[index].changeDiceState();
      allDicesLocked = checkAllDicesLocked();
      print("allDicesLocked" + allDicesLocked.toString());
    });
  }

  bool checkAllDicesLocked() {
    print("function checkAllDicesLocked");
    for (var dice in dices) {
      if (!dice.getDiceState()) {
        return false;
      }
    }
    return true;
  }

  Color setColor(String buttonCategory, int buttonValue) {
    if (buttonCategory == this.category &&
        (buttonValue == 0 || buttonValue == this.value)) {
      // selected
      return kActiveCardColor;
    } else if (kniffel.checkAlreadyCompleted(buttonCategory, buttonValue)) {
      // completed
      return kCompletedCardColor;
    } else {
      // not selected
      return kInactiveCardColor;
    }
  }

  int rounds = 2;

  Gender selectedGender;
  int height = 180;
  int weight = 60;
  int age = 20;

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
              child: Row(
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  // onPress: () {
                  //   setState(() {
                  //     selectedGender = Gender.male;
                  //   });
                  // },
                  color: true ? kActiveCardColor : kInactiveCardColor,
                  cardChild: Row(
                    children: List.generate(5, (index) {
                      return Expanded(
                        child: TextButton(
                          child: Image.asset(
                            'images/dice' + dices[index].getValue() + '.png',
                          ),
                          onPressed: () {
                            lockDice(index);
                          },
                        ),
                      );
                    }),

                    //     children: List.generate(5, (index) {
                    //       return Expanded(
                    //         child: ElevatedButton(
                    //           child: Image.asset(
                    //             'images/dice' + dices[index].getValue() + '.png',
                    //           ),
                    //           onPressed: () {
                    //             lockDice(index);
                    //           },
                    //         ),

                    // ),},),
                  ),
                ),
              ),
            ],
          )),
          // Expanded(
          //   child: ReusableCard(
          //     color: kActiveCardColor,
          //     cardChild: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text(
          //           'HEIGHT',
          //           style: kLabelTextStyle,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.baseline,
          //           textBaseline: TextBaseline.alphabetic,
          //           children: <Widget>[
          //             Text(
          //               height.toString(),
          //               style: kNumberTextStyle,
          //             ),
          //             Text(
          //               'cm',
          //               style: kLabelTextStyle,
          //             )
          //           ],
          //         ),
          //         SliderTheme(
          //           data: SliderTheme.of(context).copyWith(
          //             inactiveTrackColor: Color(0xFF8D8E98),
          //             activeTrackColor: Colors.white,
          //             thumbColor: Color(0xFFEB1555),
          //             overlayColor: Color(0x29EB1555),
          //             thumbShape:
          //                 RoundSliderThumbShape(enabledThumbRadius: 15.0),
          //             overlayShape:
          //                 RoundSliderOverlayShape(overlayRadius: 30.0),
          //           ),
          //           child: Slider(
          //             value: height.toDouble(),
          //             min: 120.0,
          //             max: 220.0,
          //             onChanged: (double newValue) {
          //               setState(() {
          //                 height = newValue.round();
          //               });
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: Row(
              children: List.generate(6, (diceIndex) {
                return Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        if (!kniffel.alreadyCompleted(
                            "number", diceIndex + 1)) {
                          category = "number";
                          value = diceIndex + 1;
                          print(category + ", " + value.toString());
                        }
                      });
                    },
                    color: setColor("number", diceIndex + 1),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (diceIndex + 1).toString(),
                          style: kNumberTextStyle,
                        ),
                        Text(
                          "todo",
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(categories.length, (categoriesIndex) {
                return Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        if (!kniffel.alreadyCompleted(
                            categories[categoriesIndex], 0)) {
                          category = categories[categoriesIndex];
                          value = 0;
                          print(category + ", " + value.toString());
                        }
                      });
                    },
                    color: setColor(categories[categoriesIndex], 0),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          categories[categoriesIndex],
                          style: kLabelTextStyle,
                        ),
                        Text(
                          "todo",
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
            buttonTitle: (rounds == 0 || allDicesLocked) ? "Done" : "Dice",
            onTap: () {
              dice();
            },
          ),
        ],
      ),
    );
  }
}
