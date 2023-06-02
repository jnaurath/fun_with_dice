import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dice.dart';

class Kniffel {
  Kniffel() {}
  Map kniffelResults = {
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
  int bonus = 0;
  int sum = 0;

  Map smallStreet1 = {"1": 1, "2": 1, "3": 1, "4": 1, "5": 1, "6": 0};
  Map smallStreet2 = {"1": 0, "2": 1, "3": 1, "4": 1, "5": 1, "6": 1};
  Map largeStreet = {"1": 1, "2": 1, "3": 1, "4": 1, "5": 1, "6": 1};

  bool alreadyCompleted(String category, int value) {
    print("funktion alreadyCompleted" + category + value.toString());

    if (category == "number") {
      print("number");
      if (kniffelResults[value.toString()] != null) {
        print("true 1");
        return true;
      }
    } else if (kniffelResults[category] != null) {
      print("true 1");
      return true;
    }
    print("false");
    return false;
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

  calculateResult(category, value, List<Dice> dices) {
    print("function: calculateResult");
    int result = 0;
    switch (category) {
      case "number":
        print("category: number, value: " + value.toString());
        for (var dice in dices) {
          if (dice.getValue() == value.toString()) {
            result += value;
          }
        }
        print("result" + result.toString());
        this.kniffelResults[value.toString()] = result;
        this.checkBonus();
        break;

      case "3s":
        if (this.checkForSame(3, dices)) {
          for (var dice in dices) {
            result += int.parse(dice.getValue());
          }
        }
        this.kniffelResults[category] = result;
        break;

      case "4s":
        if (this.checkForSame(4, dices)) {
          for (var dice in dices) {
            result += int.parse(dice.getValue());
          }
        }
        this.kniffelResults[category] = result;
        break;

      case "smallStreet":
        if (checkForStreet(dices) == "small") {
          this.kniffelResults[category] = 30;
        } else {
          this.kniffelResults[category] = 0;
        }
        break;

      case "largeStreet":
        if (checkForStreet(dices) == "small") {
          this.kniffelResults[category] = 40;
        } else {
          this.kniffelResults[category] = 0;
        }
        break;

      case "FullHouse":
        if (checkForFullHouse(dices)) {
          this.kniffelResults[category] = 25;
        } else {
          this.kniffelResults[category] = 0;
        }
        break;

      case "Kniffel":
        if (this.checkForSame(5, dices)) {
          this.kniffelResults[category] = 50;
        } else {
          this.kniffelResults[category] = 0;
        }
        break;

      case "Chance":
        for (var dice in dices) {
          result += int.parse(dice.getValue());
        }
        this.kniffelResults[category] = result;
        break;
      default:
    }
    this.calculateSum();
  }

  checkBonus() {
    print("function: checkBonus");
    this.bonus = 0;
    for (var i = 1; i <= 6; i++) {
      print(i);
      if (kniffelResults[i.toString()] != null) {
        print("not null: " + i.toString());
        this.bonus += kniffelResults[i.toString()] - (i) * 3;
        print(i.toString() +
            ": " +
            kniffelResults[i.toString()].toString() +
            " --> " +
            (kniffelResults[i.toString()] - (i) * 3).toString());
      }
    }
  }

  checkForSame(value, List<Dice> dices) {
    print("function: checkForSame " + value.toString());
    Map numbers = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0};
    for (var dice in dices) {
      numbers[dice.getValue()]++;
    }
    if (numbers.values.any((value) => value > value)) {
      print("true");
      return true;
    }
    print("false");
    return false;
  }

  checkForFullHouse(List<Dice> dices) {
    print("function: checkForFullHouse");
    Map numbers = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0};
    for (var dice in dices) {
      numbers[dice.getValue()]++;
    }
    if (numbers.values.any((value) => value == 3) &&
        numbers.values.any((value) => value == 2)) {
      print("true");
      return true;
    }
    print("false");
    return false;
  }

  checkForStreet(List<Dice> dices) {
    print("function: checkForStreet");
    Map numbers = {"1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0};
    for (var dice in dices) {
      numbers[dice.getValue()]++;
    }
    print("results");
    print(numbers);

    if (mapEquals(numbers, this.smallStreet1) ||
        mapEquals(numbers, this.smallStreet1) ||
        mapEquals(numbers, this.largeStreet)) {
      print("small");
      return "small";
    }
    if (mapEquals(numbers, this.largeStreet)) {
      print("large");
      return "large";
    }
    print("false");
    return false;
  }

  calculateSum() {
    print("function: calculateSum");
    print("sum before" + this.sum.toString());
    print(this.kniffelResults);
    for (var element in kniffelResults.values) {
      if (element != null) {
        this.sum += element;
      }
    }
    print("sum after" + this.sum.toString());
  }

  checkAlreadyCompleted(String category, int value) {
    if (category == "number" && this.kniffelResults[value.toString()] != null) {
      return true;
    } else if (this.kniffelResults[category] != null) {
      return true;
    }
    return false;
  }
}
