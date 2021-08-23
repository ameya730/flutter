import 'package:flutter/material.dart';

class CElevatedButton extends StatelessWidget {
  final String? buttonLabel;
  final void Function()? onPressed;
  final IconData? icon;
  final avatorColor;
  final int buttonColor;
  CElevatedButton({
    @required this.buttonLabel,
    required this.onPressed,
    this.icon,
    this.avatorColor,
    this.buttonColor = 0xff16194F,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(buttonColor),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: FittedBox(
            child: Text(
              buttonLabel!,
              textScaleFactor: 1.2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
