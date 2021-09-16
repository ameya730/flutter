import 'package:get/get.dart';
import 'package:gshala/database/video_db.dart';
import 'package:gshala/models/2.0_videodetails_sqflite_model.dart';

class SendVideoDetailsController extends GetxController {
  final dbHelper = DatabaseProvider.db;
  final getData = false.obs;

  getVideoDetails() async {
    var list = dbHelper.getVideoStatistics();
    print(list);
    getData.value = true;
    return list;
  }
}
