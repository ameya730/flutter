import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/controllers/5.0_profile_selection_controller.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/screens/1_homepage.dart';

logOut(BuildContext context) async {
  final dbHelper = DatabaseProvider.db;
  final box = new GetStorage();
  final profileControl = Get.put(ProfileSelectioController());
  await dbHelper.deleteProfiles();
  profileControl.fetchProfiles();
  box.remove('downloadPermission');
  box.remove('userName');
  box.remove('uType');
  box.remove('userId');
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    ),
    (route) => false,
  );
}
