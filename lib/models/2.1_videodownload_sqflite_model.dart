class VideoDownload {
  int? id;
  int? userId;
  int? resourceNodeId;
  String? videoName;
  int? videoLastViewPosition;
  int? videoDeleted;

  VideoDownload({
    this.id,
    this.userId,
    this.resourceNodeId,
    this.videoName,
    this.videoLastViewPosition,
    this.videoDeleted,
  });

  VideoDownload.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        userId = res['UserId'],
        resourceNodeId = res['ResourceNodeId'],
        videoName = res['videoName'],
        videoLastViewPosition = res['videoLastViewPosition'],
        videoDeleted = res['videoDeleted'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'resourceNodeid': resourceNodeId,
      'videoName': videoName,
      'videoLastViewPosition': videoLastViewPosition,
      'videoDeleted': videoDeleted,
    };
  }
}
