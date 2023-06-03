import 'package:flutter/material.dart';
import 'package:fun_with_dice/screens/dice_page.dart';

import 'constants.dart';

void main() => runApp(FunWithDice());

class FunWithDice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: colorPalette4,
        scaffoldBackgroundColor: colorPalette2,
      ),
      home: DicePage(),
    );
  }
}
