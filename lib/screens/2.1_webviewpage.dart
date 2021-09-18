import 'dart:io';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/encryption.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  final GlobalKey<ScaffoldState> _webViewScaffoldKey =
      new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
    var encuname = userEncryption(box.read('userName'));
    var url = webViewLoginIn +
        encuname +
        "&utype=" +
        box.read('uType') +
        "&mob=1234567891";
    print(url);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _webViewScaffoldKey,
          floatingActionButton: FabCircularMenu(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/offlinemainpage');
                  },
                  icon: Icon(
                    Icons.logout,
                    color: normalWhiteText,
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      color: normalWhiteText,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.login,
                    color: normalWhiteText,
                  ),
                  label: Text(
                    'New \nUser \nLogin',
                    style: TextStyle(
                      color: normalWhiteText,
                    ),
                  ),
                ),
              ),
            ],
            animationDuration: Duration(milliseconds: 10),
          ),
          body: WebView(
            initialUrl:
                'https://gshala.schoolnetindia.com/Login/MainLoginSL?uname=U2FsdGVkX1+0I+3D0D3oZRf/I4JhMXtqGAtwW0FH5B8=&utype=student&mob=1234567891',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
          ),
        ),
      ),
    );
  }
}
