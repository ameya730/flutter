// To parse this JSON data, do
//
//     final userProfiles = userProfilesFromJson(jsonString);

import 'dart:convert';

List<UserProfiles> userProfilesFromJson(String str) => List<UserProfiles>.from(
    json.decode(str).map((x) => UserProfiles.fromJson(x)));

String userProfilesToJson(List<UserProfiles> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserProfiles {
  UserProfiles({
    this.userName,
    this.firstName,
    this.lastName,
    this.userId,
    this.profilePic,
    this.mobileNumber,
    this.gender,
    this.batchname,
  });

  String? userName;
  String? firstName;
  String? lastName;
  int? userId;
  dynamic profilePic;
  String? mobileNumber;
  String? gender;
  String? batchname;

  factory UserProfiles.fromJson(Map<String, dynamic> json) => UserProfiles(
        userName: json["UserName"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        userId: json["UserId"],
        profilePic: json["ProfilePic"],
        mobileNumber: json["MobileNumber"],
        gender: json["Gender"],
        batchname: json["Batchname"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "FirstName": firstName,
        "LastName": lastName,
        "UserId": userId,
        "ProfilePic": profilePic,
        "MobileNumber": mobileNumber,
        "Gender": gender,
        "Batchname": batchname,
      };
}
