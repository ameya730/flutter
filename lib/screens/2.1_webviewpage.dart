import 'dart:convert';
import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
import 'package:gshala/controllers/3.0_videodownload_controller.dart';
import 'package:gshala/encryption.dart';
import 'package:gshala/models/3.0_videodownload_model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  // ignore: unused_field
  late WebViewController _controller;
  final GlobalKey<ScaffoldState> _webViewScaffoldKey =
      new GlobalKey<ScaffoldState>();
  VideoDownloadController videoDownloadController =
      Get.put(VideoDownloadController());
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
          floatingActionButton: webViewFloatingScroller(context),
          body: Stack(
            children: [
              WebView(
                initialUrl:
                    'https://lms.schoolnetindia.com/gujaratlms/Login/MainLoginSL?uname=U2FsdGVkX19OSbRuyg6l+yHDUhG2wdd/CnCqZR4+0u4=&utype=student&mob=1234567891',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
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
                      name: 'typeOf',
                      onMessageReceived: (JavascriptMessage message) {
                        print(message.message);
                      },
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  return videoDownloadController.isdownloading.value
                      ? AlertDialog(
                          title: Text('Downloading Video...'),
                          content: Text(
                            videoDownloadController.progressPercentage
                                .toString(),
                          ),
                          actions: [
                            Obx(() {
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
                            })
                          ],
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
              Get.offAndToNamed('/offlinemainpage');
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
            onPressed: () {},
            icon: Icon(
              Icons.login,
              color: normalWhiteText,
            ),
            label: Text(
              'Change Profile'.tr,
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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextButton.icon(
            onPressed: () async {
              LanguageController lControl = Get.put(LanguageController());
              if (lControl.selectedLanguage.value == 'English') {
                lControl.selectedLanguage.value = 'ગુજરાતી';
              } else if (lControl.selectedLanguage.value == 'ગુજરાતી') {
                lControl.selectedLanguage.value = 'English';
              }
              lControl.changeLangauge();
            },
            icon: Icon(
              Icons.language_sharp,
              color: normalWhiteText,
            ),
            label: Text(
              'Language'.tr,
              style: TextStyle(
                color: normalWhiteText,
              ),
            ),
          ),
        ),
      ],
      animationDuration: Duration(milliseconds: 10),
    );
  }
}
