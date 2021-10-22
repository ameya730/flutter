import 'package:get/get.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/1.1_userprofiles_sqlite_model.dart';

class ProfileSelectioController extends GetxController {
  final isProfileSelected = false.obs;
  final listOfProfiles = <UserProfiles>[].obs;
  final dbHelper = DatabaseProvider.db;
  final profileListObtained = false.obs;

  @override
  void onInit() {
    fetchProfiles();
    super.onInit();
  }

  fetchProfiles() async {
    listOfProfiles.clear();
    var profiles = await dbHelper.getAllProfiles();
    listOfProfiles.value = profiles;
    profileListObtained.value = true;
  }
}
