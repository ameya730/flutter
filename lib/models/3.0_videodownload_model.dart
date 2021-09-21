// To parse this JSON data, do
//
//     final videoDownloaded = videoDownloadedFromJson(jsonString);

import 'dart:convert';

VideoDownloaded videoDownloadedFromJson(String str) =>
    VideoDownloaded.fromJson(json.decode(str));

String videoDownloadedToJson(VideoDownloaded data) =>
    json.encode(data.toJson());

class VideoDownloaded {
  VideoDownloaded({
    this.nodeid,
    this.vidUrl,
    this.nodename,
    this.topic,
    this.chapter,
    this.videoDownloadedClass,
    this.subjectName,
  });

  String? nodeid;
  String? vidUrl;
  String? nodename;
  String? topic;
  String? chapter;
  String? videoDownloadedClass;
  String? subjectName;

  factory VideoDownloaded.fromJson(Map<String, dynamic> json) =>
      VideoDownloaded(
        nodeid: json["nodeid"],
        vidUrl: json["vid_url"],
        nodename: json["nodename"],
        topic: json["Topic"],
        chapter: json["chapter"],
        videoDownloadedClass: json["Class"],
        subjectName: json["SubjectName"],
      );

  Map<String, dynamic> toJson() => {
        "nodeid": nodeid,
        "vid_url": vidUrl,
        "nodename": nodename,
        "Topic": topic,
        "chapter": chapter,
        "Class": videoDownloadedClass,
        "SubjectName": subjectName,
      };
}
