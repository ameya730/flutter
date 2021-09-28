import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.snapchat.android",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status!,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " +
          "${status.localVersion}" +
          " to " +
          "${status.storeVersion}",
      dismissAction: () {
        Navigator.pop(context);
      },
      updateButtonText: "Lets update",
    );

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
