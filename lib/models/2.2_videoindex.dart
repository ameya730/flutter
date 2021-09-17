// To parse this JSON data, do
//
//     final videoIndex = videoIndexFromJson(jsonString);

import 'dart:convert';

List<VideoIndex> videoIndexFromJson(String str) =>
    List<VideoIndex>.from(json.decode(str).map((x) => VideoIndex.fromJson(x)));

String videoIndexToJson(List<VideoIndex> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoIndex {
  VideoIndex({
    this.nodeid,
    this.nodename,
    this.topic,
    this.vidUrl,
    this.chapter,
    this.videoIndexClass,
    this.subjectName,
  });

  int? nodeid;
  String? nodename;
  String? topic;
  String? vidUrl;
  String? chapter;
  String? videoIndexClass;
  String? subjectName;

  factory VideoIndex.fromJson(Map<String, dynamic> json) => VideoIndex(
        nodeid: json["nodeid"],
        nodename: json["nodename"],
        topic: json["Topic"],
        vidUrl: json["vid_url"],
        chapter: json["chapter"],
        videoIndexClass: json["Class"],
        subjectName: json["SubjectName"],
      );

  Map<String, dynamic> toJson() => {
        "nodeid": nodeid,
        "nodename": nodename,
        "Topic": topic,
        "vid_url": vidUrl,
        "chapter": chapter,
        "Class": videoIndexClass,
        "SubjectName": subjectName,
      };
}
