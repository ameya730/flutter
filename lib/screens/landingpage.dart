import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gshala/getxnetworkmanager.dart';

class LandingPage extends StatelessWidget {
  final GetXNetworkManager networkManager = Get.put(GetXNetworkManager());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
