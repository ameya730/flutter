import 'package:flutter/material.dart';

class NoLoginOfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
            children: [
              Text(
                'You are offline. Kindly ensure that you have an active internet connection to proceed',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
