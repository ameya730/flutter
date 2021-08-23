import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('Welcome to G-Shala. You are now online'),
            ],
          ),
        ),
      ),
    );
  }
}
