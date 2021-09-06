class VideoDetails {
  int? id;
  String? videoName;
  int? videoViewCounter;
  int? videoLastPosition;
  int? videoTotalViewDuration;
  int videoDataUpdated;
  int videoDeleted;
  VideoDetails({
    this.id,
    this.videoName,
    this.videoViewCounter,
    this.videoLastPosition,
    this.videoTotalViewDuration,
    this.videoDataUpdated = 0,
    this.videoDeleted = 0,
  });

  VideoDetails.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        videoName = res['videoName'],
        videoViewCounter = res['videoViewCounter'],
        videoLastPosition = res['videoLastPosition'],
        videoTotalViewDuration = res['videoTotalViewDuration'],
        videoDataUpdated = res['videoDataUpdated'],
        videoDeleted = res['videoDeleted'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'videoName': videoName,
      'videoViewCounter': videoViewCounter,
      'videoLastPosition': videoLastPosition,
      'videoTotalViewDuration': videoTotalViewDuration,
      'videoDataUpdated': videoDataUpdated,
      'videoDeleted': videoDeleted,
    };
  }
}
