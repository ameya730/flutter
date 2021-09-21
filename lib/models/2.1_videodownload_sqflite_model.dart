class VideoDownload {
  int? id;
  int? userId;
  int? resourceNodeId;
  int? videoLastViewPosition;
  String? videoName;
  int? videoDeleted;
  String? videoId;
  String? videoURL;
  String? nodeName;
  String? topic;
  String? chapter;
  String? videoClass;
  String? subjectName;

  VideoDownload({
    this.id,
    this.userId,
    this.resourceNodeId,
    this.videoLastViewPosition,
    this.videoName,
    this.videoDeleted,
    this.videoId,
    this.videoURL,
    this.nodeName,
    this.chapter,
    this.videoClass,
    this.subjectName,
    this.topic,
  });

  VideoDownload.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        userId = res['UserId'],
        resourceNodeId = res['ResourceNodeId'],
        videoLastViewPosition = res['videoLastViewPosition'],
        videoName = res['videoName'],
        videoDeleted = res['videoDeleted'],
        videoId = res['nodeid'],
        videoURL = res['vid_url'],
        nodeName = res['nodename'],
        topic = res['Topic'],
        chapter = res['chapter'],
        videoClass = res['Class'],
        subjectName = res['SubjectName'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'resourceNodeid': resourceNodeId,
      'videoLastViewPosition': videoLastViewPosition,
      'videoName': videoName,
      'videoDeleted': videoDeleted,
      'nodeid': videoId,
      'vid_url': videoURL,
      'nodename': nodeName,
      'chapter': chapter,
      'Class': videoClass,
      'subjectName': subjectName,
      'Topic': topic,
    };
  }
}
