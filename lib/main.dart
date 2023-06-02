import 'package:flutter/material.dart';
import 'package:fun_with_dice/screens/dice_page.dart';

void main() => runApp(FunWithDice());

class FunWithDice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: DicePage(),
    );
  }
}
