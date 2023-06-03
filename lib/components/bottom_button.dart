import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fun_with_dice/classes/kniffel.dart';
import 'package:fun_with_dice/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton(
      {@required this.onTap,
      @required this.buttonTitle,
      @required this.disabled,
      @required this.rounds});

  final Function onTap;
  final String buttonTitle;
  bool disabled;
  int rounds;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !this.disabled ? this.onTap : null,
      child: Container(
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      buttonTitle,
                      style: kLargeButtonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                rounds,
                (index) => Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 15, 0),
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    FontAwesomeIcons.dice,
                    size: 30.0,
                  ),
                ),
              ),
            )
          ],
        ),
        // child: Row(children: [
        //   Expanded(
        //     child: Align(
        //       alignment: Alignment.center,
        //       child: Text(
        //         buttonTitle,
        //         style: kLargeButtonTextStyle,
        //       ),
        //     ),
        //   ),
        //   Row(
        //     children:
        //         List.generate(rounds, (index) => Icon(FontAwesomeIcons.dice)),
        //   )
        // ]),

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
