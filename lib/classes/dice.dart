import 'package:flutter/material.dart';
import 'dart:math';

class Dice {
  Dice() {
    dice();
  }

  int value = 1;
  bool locked = false;

  dice() {
    if (!this.locked) {
      this.value = Random().nextInt(6) + 1;
    }
  }

  String getValue() {
    return this.value.toString();
  }

  changeDiceState() {
    print("function changeDiceState");
    this.locked = !this.locked;
  }

  setDiceState(bool value) {
    this.locked = value;
  }

  bool getDiceState() {
    return this.locked;
  }
}
