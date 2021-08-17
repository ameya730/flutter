import 'package:flutter/material.dart';

class CElevatedButton extends StatelessWidget {
  final String? buttonLabel;
  final void Function()? onPressed;
  CElevatedButton({@required this.buttonLabel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        elevation: 8,
      ),
      onPressed: onPressed,
      child: FittedBox(
        child: Text(
          buttonLabel!,
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).backgroundColor),
        ),
      ),
    );
  }
}
