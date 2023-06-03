import 'package:flutter/material.dart';
import 'package:fun_with_dice/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton(
      {@required this.onTap,
      @required this.buttonTitle,
      @required this.disabled});

  final Function onTap;
  final String buttonTitle;
  bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !this.disabled ? this.onTap : null,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kLargeButtonTextStyle,
          ),
        ),
        color: !this.disabled
            ? kBottomContainerColor
            : kBottomDisabledContainerColor,
        margin: EdgeInsets.only(top: 10.0),
        padding: EdgeInsets.only(bottom: 20.0),
        width: double.infinity,
        height: kBottomContainerHeight,
      ),
    );
  }
}
