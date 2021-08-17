import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/templates/customtextfield.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Offline Videos'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'Login',
                textScaleFactor: 1.5,
              ),
              CustomTextField(
                cLabelText: 'UserName',
              ),
              CustomTextField(
                cLabelText: 'Password',
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/viewvideopage');
                },
                child: Text('View Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
