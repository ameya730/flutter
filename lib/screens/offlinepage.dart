import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/templates/custombutton.dart';

class OfflineMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('You are Offline'),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/offlineimage.gif',
                  height: 300,
                  width: 300,
                ),
                Container(
                  width: 300,
                  child: Text(
                    'You are offline. \nPlease click the below button to see the list of all videos that you have downloaded',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                CElevatedButton(
                    buttonLabel: 'Offline Videos',
                    onPressed: () {
                      Get.toNamed('/offlinevideoslist');
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
