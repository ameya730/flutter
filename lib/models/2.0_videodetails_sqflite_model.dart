class VideoDetails {
  int? id;
  int? userId;
  int? lessonPlanId;
  int? resourceNodeId;
  String? docType;
  String? videoInitializeDate;
  int? videoDuration;
  int? videoStartTime;
  int? videoEndTime;
  String? videoViewDate;
  int? videoViewCompleted;
  String? videoViewCompletedDate;
  int? videoTotalViewDuration;
  String? videoName;
  int? videoViewCounter;
  int? videoLastPosition;
  int videoDataUpdated;
  int videoDeleted;
  VideoDetails({
    this.id,
    this.userId,
    this.lessonPlanId,
    this.resourceNodeId,
    this.docType,
    this.videoInitializeDate,
    this.videoDuration,
    this.videoStartTime,
    this.videoEndTime,
    this.videoViewDate,
    this.videoViewCompleted,
    this.videoViewCompletedDate,
    this.videoTotalViewDuration,
    this.videoName,
    this.videoDataUpdated = 0,
    this.videoDeleted = 0,
  });

  VideoDetails.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        userId = res['UserId'],
        lessonPlanId = res['LessonPlanId'],
        resourceNodeId = res['ResourceNodeId'],
        docType = res['Type'],
        videoInitializeDate = res['CreatedOn'],
        videoDuration = res['TotalTime'],
        videoStartTime = res['StartTime'],
        videoEndTime = res['EndTime'],
        videoViewDate = res['ModifiedOn'],
        videoViewCompleted = res['IsCompleted'],
        videoViewCompletedDate = res['CompletedDate'],
        videoTotalViewDuration = res['TotalTimeSpent'],
        videoName = res['videoName'],
        videoDataUpdated = res['videoDataUpdated'],
        videoDeleted = res['videoDeleted'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'UserId': userId,
      'LessonPlanId': lessonPlanId,
      'ResourceNodeId': resourceNodeId,
      'Type': docType,
      'CreatedOn': videoInitializeDate,
      'TotalTime': videoDuration,
      'StartTime': videoStartTime,
      'EndTime': videoEndTime,
      'ModifiedOn': videoViewDate,
      'IsCompleted': videoViewCompleted,
      'CompletedDate': videoViewCompletedDate,
      'TotalTimeSpent': videoTotalViewDuration,
      'videoName': videoName,
      'videoDataUpdated': videoDataUpdated,
      'videoDeleted': videoDeleted,
    };
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'UserId': userId,
      'LessonPlanId': lessonPlanId,
      'ResourceNodeId': resourceNodeId,
      'Type': docType,
      'CreatedOn': videoInitializeDate,
      'TotalTime': videoDuration,
      'StartTime': videoStartTime,
      'EndTime': videoEndTime,
      'ModifiedOn': videoViewDate,
      'IsCompleted': videoViewCompleted,
      'CompletedDate': videoViewCompletedDate,
      'TotalTimeSpent': videoTotalViewDuration,
    };
    return map;
  }
}
