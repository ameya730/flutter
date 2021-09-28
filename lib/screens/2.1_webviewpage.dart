import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
import 'package:gshala/controllers/2.5_offlinevideoview_controller.dart';
import 'package:gshala/controllers/3.0_videodownload_controller.dart';
import 'package:gshala/controllers/2.3_pdfview_controller.dart';
import 'package:gshala/cryptojs_aes_encryption_helper.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/3.0_videodownload_model.dart';
import 'package:gshala/screens/1_homepage.dart';
import 'package:gshala/screens/2.2_offlinemainpage.dart';
import 'package:gshala/templates/custombutton.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

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
  final OfflineVideosPageView offlineVideosPageView =
      Get.put(OfflineVideosPageView());
  final dbHelper = DatabaseProvider.db;
  final LanguageController languageController = Get.put(LanguageController());

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
                : buildSpeedTray();
          }),
          body: Stack(
            children: [
              WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                allowsInlineMediaPlayback: true,
                onWebViewCreated: (WebViewController c) {
                  _controllerCompleter.future
                      .then((value) => controller = value);
                  _controllerCompleter.complete(c);
                  controller = c;
                },
                debuggingEnabled: true,
                initialMediaPlaybackPolicy:
                    AutoMediaPlaybackPolicy.always_allow,
                gestureNavigationEnabled: true,
                javascriptChannels: Set.from(
                  [
                    JavascriptChannel(
                      name: 'vdownload',
                      onMessageReceived: (JavascriptMessage message) async {
                        VideoDownloaded videoData = VideoDownloaded.fromJson(
                          json.decode(message.message),
                        );
                        print(message.message);
                        await duplicateVideoCheck(
                          int.parse(
                            videoData.nodeid.toString(),
                          ),
                        );
                        if (videoDownloadController.duplicateCount.value ==
                            false) {
                          downloadVideoFunction(videoData);
                        } else if (videoDownloadController
                                .duplicateCount.value ==
                            true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Video has already been download'),
                            ),
                          );
                        }
                      },
                    ),
                    JavascriptChannel(
                      name: 'toggleFullScreen',
                      onMessageReceived: (JavascriptMessage message) async {
                        print('the value is');
                        print(message.message);
                        controller.evaluateJavascript(message.message);
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
                    JavascriptChannel(
                      name: 'getProfiles',
                      onMessageReceived: (JavascriptMessage message) {
                        print(message.message);
                      },
                    ),
                    JavascriptChannel(
                      name: 'getSessionStatus',
                      onMessageReceived: (JavascriptMessage message) {
                        print(message.message);
                        controller.reload();
                      },
                    ),
                    JavascriptChannel(
                      name: 'changeLanguage',
                      onMessageReceived: (JavascriptMessage message) {
                        print('The language is ');
                        print(message.message);
                        languageController.webViewLanguage.value =
                            message.message;
                        languageController.changeLanguageWebView();
                      },
                    ),
                    JavascriptChannel(
                      name: 'changeProfile',
                      onMessageReceived: (JavascriptMessage message) {
                        print('The profile is ');
                        print(message.message);
                        decryptAESCryptoJS(
                          message.message,
                          '0000000000000',
                        );
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
                      ? Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: normalWhiteText,
                            child: Obx(() {
                              return videoDownloadController.isdownloading.value
                                  ? Column(
                                      children: [
                                        Text(
                                          'Downloading Video',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          color: normalDarkText,
                                          height: 20,
                                          width: videoDownloadController
                                              .progressPercentage.value,
                                        ),
                                        Obx(() {
                                          return videoDownloadController
                                                  .downloadComplete.value
                                              ? CElevatedButton(
                                                  buttonLabel: 'Ok',
                                                  onPressed: () {
                                                    videoDownloadController
                                                        .isdownloading
                                                        .value = false;
                                                    videoDownloadController
                                                        .downloadComplete
                                                        .value = false;
                                                  })
                                              : CElevatedButton(
                                                  buttonLabel:
                                                      'Cancel Download',
                                                  onPressed: () {
                                                    videoDownloadController
                                                        .isdownloading
                                                        .value = false;
                                                    videoDownloadController
                                                        .downloadComplete
                                                        .value = false;
                                                    videoDownloadController
                                                        .stopDownload();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Download cancelled'),
                                                      ),
                                                    );
                                                  });
                                        }),
                                      ],
                                    )
                                  : Container();
                            }),
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

  duplicateVideoCheck(int nodeId) async {
    var count = 0;
    count = await dbHelper.videoDownloadControl(nodeId);
    if (count != 0) {
      videoDownloadController.duplicateCount.value = true;
    } else {
      videoDownloadController.duplicateCount.value = false;
    }
  }

  downloadVideoFunction(VideoDownloaded videoDownloaded) async {
    await videoDownloadController.downloadFile(videoDownloaded);
  }

  SpeedDial buildSpeedTray() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Theme.of(context).backgroundColor,
      visible: true,
      curve: Curves.bounceInOut,
      spaceBetweenChildren: 10,
      spacing: 10,
      children: [
        SpeedDialChild(
          child: Icon(Icons.chrome_reader_mode, color: Colors.white),
          backgroundColor: Theme.of(context).backgroundColor,
          onTap: () {
            offlineVideosPageView.isOfflineVideoPageOpen.value = true;
            Get.to(() => PostLoginOfflineMainPage());
          },
          label: 'Offline Videos'.tr,
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(Icons.logout_rounded, color: Colors.white),
          backgroundColor: Theme.of(context).backgroundColor,
          onTap: () {
            box.remove('userName');
            box.remove('uType');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
              (route) => false,
            );
          },
          label: 'Log Out'.tr,
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  pdfBackButton() {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).backgroundColor,
      onPressed: () {
        pdfViewController.closePDF();
      },
      label: Text('Return'.tr),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
