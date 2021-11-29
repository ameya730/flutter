import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

androidPlatform() async {
  await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _signUpScaffoldKey =
      new GlobalKey<ScaffoldState>();

  InAppWebViewController? controller;
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
              url: Uri.parse(forgotPassword),
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
                  print(args);
                  if (args[0] == 'true') {
                    Get.offAndToNamed('/homepage');
                  }
                },
              );
            },
            onConsoleMessage: (controller, consoleMessage) {
              print(consoleMessage);
            },
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
