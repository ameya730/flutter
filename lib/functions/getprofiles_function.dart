import 'package:get/get.dart';
import 'package:gshala/controllers/5.0_profile_selection_controller.dart';

getProfilesFunction() async {
  final profileControl = Get.put(ProfileSelectioController());
  await profileControl.fetchProfiles();
}
