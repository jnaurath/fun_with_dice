import 'package:flutter/material.dart';
import 'dart:math';

class Dice {
  Dice(String name) {
    this.name = name;
    print("Dice constructed + " + name);
    dice();
  }

  int value = 1;
  bool locked = false;
  String name;

  dice() {
    if (!this.locked) {
      this.value = Random().nextInt(6) + 1;
    }
  }

  getValue() {
    return this.value.toString();
  }

  changeDiceState() {
    this.locked = !this.locked;
  }

  setDiceState(value) {
    this.locked = value;
  }

  getDiceState() {
    return this.locked;
  }

  getName() {
    return this.name;
  }
}
