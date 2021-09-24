import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/3.0_videodownload_controller.dart';
import 'package:gshala/controllers/pdfview_controller.dart';
import 'package:gshala/cryptojs_aes_encryption_helper.dart';
import 'package:gshala/models/3.0_videodownload_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with AutomaticKeepAliveClientMixin<WebViewPage> {
  late WebViewController controller;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  final GlobalKey<ScaffoldState> _webViewScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final VideoDownloadController videoDownloadController =
      Get.put(VideoDownloadController());
  final PDFViewController pdfViewController = Get.put(PDFViewController());

  Future<bool> _onWillPop(BuildContext context) async {
    print("onwillpop");
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      return Future.value(false);
    }
    throw Exception('Issue');
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var encuname = encryptAESCryptoJS(box.read('userName'), "0000000000000");
    print(encuname);
    print(box.read('uType'));
    var url = webViewLoginIn +
        encuname +
        "&utype=" +
        box.read('uType').toString().toLowerCase() +
        "&mob=1234567891";
    print(url);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          key: _webViewScaffoldKey,
          floatingActionButton: Obx(() {
            return pdfViewController.pdfOpen.value
                ? pdfBackButton()
                : webViewFloatingScroller(context);
          }),
          body: Stack(
            children: [
              WebView(
                initialUrl: url,
                // 'https://lms.schoolnetindia.com/gujaratlms/Login/MainLoginSL?uname=U2FsdGVkX19OSbRuyg6l+yHDUhG2wdd/CnCqZR4+0u4=&utype=student&mob=1234567891',
                javascriptMode: JavascriptMode.unrestricted,
                allowsInlineMediaPlayback: true,
                onWebViewCreated: (WebViewController c) {
                  _controllerCompleter.future
                      .then((value) => controller = value);
                  _controllerCompleter.complete(c);
                },
                debuggingEnabled: true,
                initialMediaPlaybackPolicy:
                    AutoMediaPlaybackPolicy.always_allow,
                javascriptChannels: Set.from(
                  [
                    JavascriptChannel(
                      name: 'vdownload',
                      onMessageReceived: (JavascriptMessage message) async {
                        print(json.decode(message.message));
                        VideoDownloaded videoData = VideoDownloaded.fromJson(
                            json.decode(message.message));
                        print(videoData.nodeid.toString());
                        await downloadVideoFunction(videoData);
                      },
                    ),
                    JavascriptChannel(
                      name: 'toggleFullScreen',
                      onMessageReceived: (JavascriptMessage message) async {
                        print('the value is');
                        print(message.message);
                        // orientationController.screenOrientation.value =
                        //     message.message as bool;
                        // changeScreenOrientation();
                      },
                    ),
                    JavascriptChannel(
                      name: 'downloadPDF',
                      onMessageReceived: (JavascriptMessage message) {
                        print('The pdf is');
                        print(message.message);
                        pdfViewController.pdfPath.value = message.message;
                        pdfViewController.openPDF();
                      },
                    ),
                  ],
                ),
              ),
              Obx(() {
                return pdfViewController.pdfOpen.value
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SfPdfViewer.network(
                          pdfViewController.pdfPath.value,
                        ),
                      )
                    : Container();
              }),
              Obx(
                () {
                  return videoDownloadController.isdownloading.value
                      ? GestureDetector(
                          onTap: () {
                            videoDownloadController.isdownloading.value = false;
                          },
                          child: AlertDialog(
                            title: Text('Downloading Video...'),
                            content: Text(
                              videoDownloadController.progressPercentage
                                  .toString(),
                            ),
                            actions: [
                              Obx(
                                () {
                                  return videoDownloadController
                                          .downloadComplete.value
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok'),
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        );
                                },
                              )
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  downloadVideoFunction(VideoDownloaded videoDownloaded) async {
    print(videoDownloaded);
    await videoDownloadController.downloadFile(videoDownloaded);
    print(videoDownloaded.vidUrl);
  }

  webViewFloatingScroller(BuildContext context) {
    return FabCircularMenu(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextButton.icon(
            onPressed: () {
              Get.toNamed('/offlinemainpage');
            },
            icon: Icon(
              Icons.wifi_off_outlined,
              color: normalWhiteText,
            ),
            label: Text(
              'Offline Videos'.tr,
              style: TextStyle(
                color: normalWhiteText,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextButton.icon(
            onPressed: () {
              SchedulerBinding.instance!.addPostFrameCallback((_) async {
                box.remove('userName');
                await Navigator.popAndPushNamed(
                  context,
                  '/homepage',
                );
              });
            },
            icon: Icon(
              Icons.logout,
              color: normalWhiteText,
            ),
            label: Text(
              'Log Out'.tr,
              style: TextStyle(
                color: normalWhiteText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  pdfBackButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        pdfViewController.closePDF();
      },
      label: Text('Back'.tr),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
