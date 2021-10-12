import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:gshala/apis/sendvideodetails_api.dart';
import 'package:gshala/const.dart';
import 'package:gshala/controllers/1.0_language_controller.dart';
import 'package:gshala/controllers/2.2_floatingbarcontrollers.dart';
import 'package:gshala/controllers/2.4_orientation_controller.dart';
import 'package:gshala/controllers/2.5_offlinevideoview_controller.dart';
import 'package:gshala/controllers/2.6_profile_update_controller.dart';
import 'package:gshala/controllers/3.0_videodownload_controller.dart';
import 'package:gshala/controllers/2.3_pdfview_controller.dart';
import 'package:gshala/cryptojs_aes_encryption_helper.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/functions/getofflinevideos_function.dart';
import 'package:gshala/functions/logout_function.dart';
import 'package:gshala/models/1.1_userprofiles_sqlite_model.dart';
import 'package:gshala/models/3.0_videodownload_model.dart';
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
  final videoDownloadController = Get.put(VideoDownloadController());
  final pdfViewController = Get.put(PDFViewController());
  final offlineVideosPageView = Get.put(OfflineVideosPageView());
  final languageController = Get.put(LanguageController());
  final orientationController = Get.put(OrientationController());
  final floatingController = Get.put(FloatingBarControllers());
  final profileUpdateController = Get.put(ProfileUpdateController());

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
    var encuname = encryptAESCryptoJS(
      box.read('userName'),
      "0000000000000",
    );
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
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Obx(
            () {
              return pdfViewController.pdfOpen.value
                  ? pdfBackButton()
                  : Obx(
                      () {
                        return floatingController.hideNavigationBar.value
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : FloatingActionButton(
                                backgroundColor: backGroundColor,
                                elevation: 5,
                                tooltip: 'Downloaded Videos Page'.tr,
                                child: Icon(
                                  Icons.web_stories,
                                  color: normalWhiteText,
                                ),
                                onPressed: () {
                                  moveToOfflineDialogBox();
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
                    mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true,
                    allowFileAccessFromFileURLs: true,
                    javaScriptCanOpenWindowsAutomatically: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    hardwareAcceleration: false,
                  ),
                ),
                onWebViewCreated: (c) {
                  controller = c;
                  c.addJavaScriptHandler(
                    handlerName: 'vdownload',
                    callback: (args) async {
                      var data = json.decode(args.toString());
                      VideoDownloaded videoData =
                          VideoDownloaded.fromJson(data[0]);
                      await duplicateVideoCheck(
                        int.parse(
                          videoData.nodeid.toString(),
                        ),
                      );
                      if (videoDownloadController.duplicateCount.value ==
                          false) {
                        floatingController.hideNavigationBar.value = true;
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
                      if (args[0] == 'true') {
                        orientationController.screenOrientation.value = true;
                      } else if (args[0] == 'false') {
                        orientationController.screenOrientation.value = false;
                      }
                      changeScreenOrientation();
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'downloadPDF',
                    callback: (args) {
                      pdfViewController.pdfPath.value = args[0];
                      floatingController.hideNavigationBar.value = true;
                      pdfViewController.openPDF();
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'getProfiles',
                    callback: (args) {
                      floatingController.hideNavigationBar.value = true;
                      print('The profiles are');
                      print(args);
                      var data = args[0];
                      print('The data is $data');
                      var profiles = userProfilesFromJson(data);
                      profiles.forEach((element) {
                        print(element.firstName);
                        insertIntoDatabase(
                          int.parse(
                            element.userId.toString(),
                          ),
                          element,
                        );
                      });
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'getSessionStatus',
                    callback: (args) {
                      print(args);
                      if (args[0].toString().toLowerCase() == 'timedout') {
                        c.reload();
                      } else if (args[0].toString().toLowerCase() == 'logout') {
                        logOut(context);
                      }
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'changeLanguage',
                    callback: (args) {
                      print(args);
                      toggleLanguage(args[0].toString());
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'changeProfile',
                    callback: (args) {
                      print(args);
                      print('Check $args[0]');
                      box.write('userId', args[0].toString());
                      Future.delayed(Duration(seconds: 2)).then((value) {
                        floatingController.hideNavigationBar.value = false;
                      });
                    },
                  );
                  c.addJavaScriptHandler(
                    handlerName: 'checkplatformready',
                    callback: (args) {
                      print('ready');
                      return 'true';
                    },
                  );
                },
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage.message);
                  print(ConsoleMessageLevel.values);
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
                    : Container(
                        height: 0,
                        width: 0,
                      );
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
                                                  floatingController
                                                      .hideNavigationBar
                                                      .value = false;
                                                })
                                            : Container(
                                                child: CElevatedButton(
                                                  buttonLabel:
                                                      'Cancel Download'.tr,
                                                  onPressed: () async {
                                                    await videoDownloadController
                                                        .cancelDownload();
                                                    floatingController
                                                        .hideNavigationBar
                                                        .value = false;
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
                  return languageController.changeLanguage.value
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: normalDarkText,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Language Changed'.tr,
                                  style: TextStyle(
                                    color: normalWhiteText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CElevatedButton(
                                    buttonLabel: 'Ok'.tr,
                                    onPressed: () {
                                      languageController.languageChanged.value =
                                          false;
                                      languageController.changeLanguage.value =
                                          false;
                                    }),
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
              Obx(
                () {
                  return floatingController.hideNavigationBar.value
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
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
              Obx(
                () {
                  return orientationController.screenOrientation.value
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black87,
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

  insertIntoDatabase(int userId, UserProfiles userProfiles) async {
    var count = 0;
    count = await dbHelper.profileDuplicateControl(userId);
    if (count != 0) {
      profileUpdateController.isDuplicate.value = true;
      print('user profile duplicate');
      print(profileUpdateController.isDuplicate.value);
    } else {
      profileUpdateController.isDuplicate.value = false;
      print('updating database');
      await profileUpdateController.insertProfileInDatabase(userProfiles);
    }
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

  toggleLanguage(String languageId) async {
    languageController.changeLanguage.value = true;
    languageController.webViewLanguage.value = languageId;
    languageController.changeLanguageWebView();
    languageController.languageChanged.value = true;
  }

  downloadVideoFunction(VideoDownloaded videoDownloaded) async {
    await videoDownloadController.downloadFile(videoDownloaded);
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
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ],
      );
    }
  }

  moveToOfflineDialogBox() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('View Downloaded Videos'.tr),
            content: Text('Do you wish to view downloaded videos ?'.tr),
            actions: [
              CElevatedButton(
                  buttonLabel: 'Yes'.tr,
                  onPressed: () {
                    Navigator.pop(context, false);
                    moveToOffline();
                  }),
              CElevatedButton(
                  buttonLabel: 'No'.tr,
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
            ],
          );
        });
  }

  pdfBackButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).backgroundColor,
        onPressed: () {
          pdfViewController.closePDF();
          floatingController.hideNavigationBar.value = false;
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text('Return'.tr),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
