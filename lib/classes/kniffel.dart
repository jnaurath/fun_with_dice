import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dice.dart';
import 'dart:async';

class Kniffel {
  final confettiController = ConfettiController();
  bool isConfettiPlaying = false;

  Kniffel() {
    startGame();
  }

  List<Dice> dices = [];
  Map kniffelResults = {};
  int bonusDiff = 0;
  int bonus = 0;
  int sum = 0;
  int rounds = 2;
  bool allDicesLocked = false;
  bool endNextRound = false;

  Map smallStreet1 = {"1": 1, "2": 1, "3": 1, "4": 1, "5": 1, "6": 0};
  Map smallStreet2 = {"1": 0, "2": 1, "3": 1, "4": 1, "5": 1, "6": 1};
  Map largeStreet = {"1": 1, "2": 1, "3": 1, "4": 1, "5": 1, "6": 1};

  List<int> getAllDiceValues() {
    List<int> results = [];
    for (var dice in dices) {
      results.add(int.parse(dice.getValue()));
    }
    return results;
  }

  bool gameFinished() {
    print("funktion gameFinished");
    for (var element in kniffelResults.values) {
      if (element == null) {
        return false;
      }
    }
    return true;
  }

  void startGame() {
    dices = [
      new Dice(),
      new Dice(),
      new Dice(),
      new Dice(),
      new Dice(),
    ];
    kniffelResults = {
      "1": null,
      "2": null,
      "3": null,
      "4": null,
      "5": null,
      "6": null,
      "3s": null,
      "4s": null,
      "smallStreet": null,
      "largeStreet": null,
      "FullHouse": null,
      "Kniffel": null,
      "Chance": null,
    };
    bonusDiff = 0;
    bonus = 0;
    sum = 0;
    allDicesLocked = false;
    rounds = 2;
    endNextRound = false;
  }

  // void printDice() {
  //   for (var dice in this.dices) {
  //     print(dice.getValue());
  //   }
  // }

  void resetRound() {
    for (var dice in this.dices) {
      dice.setDiceState(false);
    }
    this.rounds = 3;
    this.nextRound("", false);
  }

  void nextRound(String category, bool forceNextRound) {
    print("function nextRound");
    this.confettiController.stop();
    if (this.endNextRound) {
      this.startGame();
    } else if (rounds > 0 && !forceNextRound && !this.checkAllDicesLocked()) {
      this.rounds--;

      this.rollDice();
      this.calculateResult(category);
    } else {
      if (this.gameFinished()) {
        print('should route to next ResultsPage');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ResultsPage()),
        // );
        // } else {
        //   rounds = 2;
        //   for (var dice in dices) {
        //     dice.setDiceState(false);
        //     dice.dice();
        //   }
        //   category = "";
        //   value = 0;
        // }
        this.startGame();
      } else {
        this.addResult(category);
        print("end of rounds");
      }
      this.resetRound();
      print("Rounds left: " + (this.rounds).toString());
      if (this.gameFinished()) {
        this.endNextRound = true;
      }
    }
  }

  void rollDice() {
    for (var dice in this.dices) {
      dice.dice();
    }
  }

  bool checkAllDicesLocked() {
    for (var dice in this.dices) {
      if (!dice.getDiceState()) {
        return false;
      }
    }
    return true;
  }

  void addResult(String category) {
    print("function: addResult");
    this.kniffelResults[category] = this.calculateResult(category);
    this.checkBonus();
    this.calculateSum();
  }

  int calculateResult(String category) {
    int result = 0;
    switch (category) {
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
      case "6":
        for (var dice in this.dices) {
          if (dice.getValue() == category) {
            result += int.parse(category);
          }
        }
        break;

      case "3s":
        if (this.checkForSame(3)) {
          for (var dice in this.dices) {
            result += int.parse(dice.getValue());
          }
        }
        break;

      case "4s":
        if (this.checkForSame(4)) {
          for (var dice in this.dices) {
            result += int.parse(dice.getValue());
          }
        }
        break;

      case "smallStreet":
        if (checkForStreet() == "small" || checkForStreet() == "large") {
          result = 30;
        } else {
          result = 0;
        }
        break;

      case "largeStreet":
        if (checkForStreet() == "large") {
          result = 40;
        } else {
          result = 0;
        }
        break;

      case "FullHouse":
        if (checkForFullHouse()) {
          result = 25;
        } else {
          result = 0;
        }
        break;

      case "Kniffel":
        if (this.checkForSame(5)) {
          result = 50;
          confettiController.play();
        } else {
          result = 0;
        }
        break;

      case "Chance":
        for (var dice in this.dices) {
          result += int.parse(dice.getValue());
        }
        break;
      default:
    }
    return result;
  }

  void checkBonus() {
    print("function: checkBonus");
    this.bonusDiff = 0;
    bool numbersCompleted = true;
    for (var i = 1; i <= 6; i++) {
      if (kniffelResults[i.toString()] != null) {
        this.bonusDiff += int.parse(kniffelResults[i.toString()] - (i) * 3);
      } else {
        numbersCompleted = false;
      }
    }
    if (numbersCompleted && this.bonusDiff >= 0) {
      this.bonus = 35;
    }
  }

  bool checkForSame(int value) {
    Map numbers = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0};
    for (var dice in this.dices) {
      numbers[dice.getValue()]++;
    }
    for (var num in numbers.values) {
      if (num >= value) {
        return true;
      }
    }
    ;
    return false;
  }

  bool checkForFullHouse() {
    Map numbers = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0};
    for (var dice in this.dices) {
      numbers[dice.getValue()]++;
    }
    if (numbers.values.any((value) => value == 3) &&
        numbers.values.any((value) => value == 2)) {
      return true;
    }
    return false;
  }

  String checkForStreet() {
    List<int> diceValues = getAllDiceValues();
    List<int> numbers = [0, 0, 0, 0, 0, 0];
    for (var dice in diceValues) {
      numbers[dice - 1]++;
    }

    int maxStreet = 0;
    int tempStreet = 0;
    for (var i = 0; i < 6; i++) {
      if (numbers[i] > 0) {
        tempStreet++;
      } else {
        if (maxStreet < tempStreet) {
          maxStreet = tempStreet;
        }
        tempStreet = 0;
      }
    }

    if (maxStreet == 5 || tempStreet == 5) {
      return "large";
    }
    if (maxStreet == 4 || tempStreet == 4) {
      return "small";
    } else {
      return "false";
    }
  }

  void calculateSum() {
    // print("function: calculateSum");
    this.sum = 0;
    print(this.kniffelResults);
    for (int element in kniffelResults.values) {
      if (element != null) {
        this.sum += element!;
      }
    }
  }

  bool checkAlreadyCompleted(String category) {
    if (this.kniffelResults[category] != null) {
      return true;
    }
    return false;
  }

  int getResult(String category) {
    if (this.kniffelResults[category] != null) {
      return this.kniffelResults[category];
    }
    return 0;
  }
}
