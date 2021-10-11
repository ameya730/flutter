import 'package:get/get.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/1.1_userprofiles_sqlite_model.dart';

class ProfileUpdateController extends GetxController {
  final dbHelper = DatabaseProvider.db;
  final isDuplicate = false.obs;
  insertProfileInDatabase(UserProfiles userProfiles) async {
    final profilesData = UserProfiles(
      userName: userProfiles.userName,
      firstName: userProfiles.firstName,
      lastName: userProfiles.lastName,
      userId: userProfiles.userId,
      profilePic: 0,
      mobileNumber: userProfiles.mobileNumber,
      gender: userProfiles.gender,
      batchname: userProfiles.batchname,
    );
    dbHelper.insertUserProfiles(profilesData);
  }
}
