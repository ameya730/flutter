import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/encryption.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
    var encuname = userEncryption(box.read('userName'));
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: webViewLoginIn +
              encuname +
              "&utype=" +
              box.read('uType') +
              "&mob=1234567891",
        ),
      ),
    );
  }
}
