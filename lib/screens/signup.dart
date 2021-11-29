import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

androidPlatform() async {
  await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
}

InAppWebViewController? controller;

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _signUpScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      androidPlatform();
    }
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
          body: InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(signUpURL),
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                allowFileAccessFromFileURLs: true,
                javaScriptCanOpenWindowsAutomatically: true,
              ),
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
              ),
            ),
            onWebViewCreated: (c) {
              controller = c;
              c.addJavaScriptHandler(
                handlerName: 'redirecttologin',
                callback: (args) {
                  print('test');
                  if (args[0] == 'true') {
                    Get.toNamed('/homepage');
                  }
                },
              );
            },
            onConsoleMessage: (controller, consoleMessage) {},
            androidOnPermissionRequest: (controller, origin, resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
          ),
        ),
      ),
    );
  }
}
