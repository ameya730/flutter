import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:gshala/apis/sendvideodetails_api.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
import 'package:gshala/controllers/2.1_videolist_controller.dart';
import 'package:gshala/controllers/2.4_orientation_controller.dart';
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
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with AutomaticKeepAliveClientMixin<WebViewPage> {
  InAppWebViewController? controller;
  final GlobalKey webViewKey = GlobalKey();
  final dbHelper = DatabaseProvider.db;
  final VideoDownloadController videoDownloadController = Get.put(
    VideoDownloadController(),
  );
  final PDFViewController pdfViewController = Get.put(
    PDFViewController(),
  );
  final OfflineVideosPageView offlineVideosPageView = Get.put(
    OfflineVideosPageView(),
  );
  final LanguageController languageController = Get.put(
    LanguageController(),
  );
  final OrientationController orientationController = Get.put(
    OrientationController(),
  );

  Future<bool> _onWillPop(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit G-Shala'.tr),
            content: Text('Do you want to exit the app ?'.tr),
            actions: [
              CElevatedButton(
                  buttonLabel: 'Yes'.tr,
                  onPressed: () {
                    exit(0);
                  }),
              CElevatedButton(
                  buttonLabel: 'No'.tr,
                  onPressed: () {
                    // Future.value(false);
                    Navigator.pop(context, false);
                  }),
            ],
          );
        });

    throw Exception('Issue');
  }

  @override
  void initState() {
    // sendVideoStatistics();
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Platform.isAndroid) {
      androidPlatform();
    }
  }

  androidPlatform() async {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // sendVideoStatistics() {
  //   SendVideoDetailsApiService sendVideoDetailsApiService =
  //       new SendVideoDetailsApiService();
  //   sendVideoDetailsApiService.sendVideoDetails().then((value) {
  //     print('success');
  //   });
  // }

  final GetStorage box = new GetStorage();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    box.write('userId', '98702');
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
        onWillPop: () => videoDownloadController.isdownloading.value
            ? Future.value(false)
            : _onWillPop(context),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Obx(
            () {
              return pdfViewController.pdfOpen.value
                  ? pdfBackButton()
                  : Obx(
                      () {
                        return videoDownloadController.isdownloading.value
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : FloatingActionButton(
                                backgroundColor: backGroundColor,
                                elevation: 0,
                                tooltip: 'Offline Video',
                                child: Icon(
                                  Icons.web_stories,
                                  color: normalWhiteText,
                                ),
                                onPressed: () async {
                                  final VideoListController
                                      videoListController =
                                      Get.put(VideoListController());
                                  videoListController.listObtained.value =
                                      false;
                                  videoListController
                                      .subjectListObtained.value = false;
                                  await videoListController.getVideosList();
                                  offlineVideosPageView
                                      .isOfflineVideoPageOpen.value = true;
                                  Get.to(() => PostLoginOfflineMainPage());
                                },
                              );
                      },
                    );
            },
          ),
          body: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(
                  url: Uri.parse(url),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true,
                    allowFileAccessFromFileURLs: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                    clearCache: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  ),
                ),
                onWebViewCreated: (c) {
                  controller = c;
                  c.addJavaScriptHandler(
                    handlerName: 'vdownload',
                    callback: (args) async {
                      print(args);
                      var data = json.decode(args.toString());
                      print('The data is $data');
                      VideoDownloaded videoData =
                          VideoDownloaded.fromJson(data[0]);
                      await duplicateVideoCheck(
                        int.parse(
                          videoData.nodeid.toString(),
                        ),
                      );
                      if (videoDownloadController.duplicateCount.value ==
                          false) {
                        await downloadVideoFunction(videoData);
                      } else if (videoDownloadController.duplicateCount.value ==
                          true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Video has already been download'),
                          ),
                        );
                      }
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'toggleFullScreen',
                    callback: (args) {
                      print(args);
                      orientationController.screenOrientation.value =
                          args as bool;
                      changeScreenOrientation();
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'downloadPDF',
                    callback: (args) {
                      print(args);
                      pdfViewController.pdfPath.value = args.toString();
                      pdfViewController.openPDF();
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'getProfiles',
                    callback: (args) {
                      print(args);
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'getSessionStatus',
                    callback: (args) {
                      print(args);
                      if (args.toString().toLowerCase() == 'timedout') {
                        controller!.reload();
                      } else if (args.toString().toLowerCase() == 'logout') {
                        logOut();
                      }
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'changeLanguage',
                    callback: (args) {
                      print(args);
                      languageController.webViewLanguage.value =
                          args.toString();
                      languageController.changeLanguageWebView();
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'changeProfile',
                    callback: (args) {
                      print('Check');
                      print(args);
                      box.write('userId', args);
                    },
                  );
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage.message);
                },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
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
                      ? videoDownloadController.downloadInProgress.value
                          ? Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.black87,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundImage: AssetImage(
                                          'assets/downloading.gif',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Downloading Video'.tr,
                                        textAlign: TextAlign.center,
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                          color: normalWhiteText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: CircularProgressIndicator(
                                              value: videoDownloadController
                                                  .progressPercentage
                                                  .toDouble(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              videoDownloadController
                                                  .progressString.value,
                                              textScaleFactor: 1.5,
                                              style: TextStyle(
                                                color: normalWhiteText,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () {
                                        return videoDownloadController
                                                .downloadComplete.value
                                            ? CElevatedButton(
                                                buttonLabel: 'Ok'.tr,
                                                onPressed: () {
                                                  videoDownloadController
                                                      .isdownloading
                                                      .value = false;
                                                  videoDownloadController
                                                      .downloadComplete
                                                      .value = false;
                                                  videoDownloadController
                                                      .downloadInProgress
                                                      .value = false;
                                                })
                                            : Container(
                                                child: CElevatedButton(
                                                  buttonLabel:
                                                      'Cancel Download'.tr,
                                                  onPressed: () async {
                                                    await videoDownloadController
                                                        .cancelDownload();
                                                    print(
                                                        videoDownloadController
                                                            .downloadInProgress
                                                            .value);
                                                  },
                                                ),
                                              );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                color: normalDarkText,
                                alignment: Alignment.center,
                                child: Text(
                                  'Download commencing'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: normalWhiteText),
                                ),
                              ),
                            )
                      : Container(
                          height: 0,
                          width: 0,
                        );
                },
              ),
              Obx(
                () {
                  return videoDownloadController.isdownloading.value
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: normalWhiteText,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () async {
                                          if (await controller!.canGoBack()) {
                                            controller!.goBack();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: normalDarkText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32.0),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        onPressed: () async {
                                          if (await controller!
                                              .canGoForward()) {
                                            controller!.goForward();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                          color: normalDarkText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {
                                  //     logOut();
                                  //   },
                                  //   icon: Icon(
                                  //     Icons.logout,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
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

  logOut() {
    box.remove('userName');
    box.remove('uType');
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(),
      ),
      (route) => false,
    );
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
          onTap: () async {
            final VideoListController videoListController =
                Get.put(VideoListController());
            videoListController.listObtained.value = false;
            videoListController.subjectListObtained.value = false;
            await videoListController.getVideosList();
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
            logOut();
          },
          label: 'Log Out'.tr,
          labelStyle:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  changeScreenOrientation() {
    if (orientationController.screenOrientation.value == true) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
    } else if (orientationController.screenOrientation.value == false) {
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
    }
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
