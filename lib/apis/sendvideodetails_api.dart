import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:gshala/const.dart';
import 'package:gshala/database/video_db.dart';
import 'package:http/http.dart' as http;

class SendVideoDetailsApiService {
  GetStorage box = new GetStorage();
  Future sendVideoDetails() async {
    var sendBody = await getDetails();
    String autho =
        'bearer Er73xqM9nxaM_1aUhjpO9CzCNGZsBGTH6djPjahWs4ylR5IAovWFebmrYamLY9P7o9mnUxffBQMooweMV1y_cBSAO9NRLGSXoNtE7JXPSvjpj4QSkMD29IlSKZohKVFUWYkjA--3hAp87FUAPRFTvFK3aYXzAdqevx7qKRiE1TkUVewq1Xbm5JcUrdOQAZjbD53E5XQQhEU8jq2ZY8ndaDd8OrfH7BvFh9_h9Nu5ye4s3SQXEvsnov0DyKwc-D4qRQ4zfJx_RiA9mh4zz0eQz7wNhRaLXGXeiKpkZgC8UgQ'; // + box.read('accessToken');
    print(autho);
    print(jsonEncode(sendBody));
    var url = Uri.parse(sendVideoDetailsUrl);
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "APIKey": "G12SHA98IZ82938KPP",
        "Authorization": autho,
      },
      body: jsonEncode(sendBody),
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      updateDatabase();
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to signin');
    }
  }

  getDetails() async {
    final dbHelper = DatabaseProvider.db;
    var data = await dbHelper.getVideoStatistics();
    print(jsonEncode(data));
    return data;
  }

  updateDatabase() async {
    final dbHelper = DatabaseProvider.db;
    await dbHelper.updateVideoDetails();
    return print('Success');
  }
}
