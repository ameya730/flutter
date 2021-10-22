import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _signUpScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _signUpScaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.offAndToNamed('/homepage');
            },
            child: Icon(
              Icons.keyboard_return_rounded,
              color: normalWhiteText,
            ),
          ),
          body: Stack(
            children: [
              WebView(
                initialUrl: signUpURL,
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from(
                  [
                    JavascriptChannel(
                      name: 'formSubmitted',
                      onMessageReceived: (JavascriptMessage message) async {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
