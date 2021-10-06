class UserProfiles {
  int? userName;
  String? firstName;
  String? lastName;
  int? userId;
  // String? profilePic;
  int? mobileNumber;
  String? gender;
  int? batchname;

  UserProfiles(
      {this.userName,
      this.firstName,
      this.lastName,
      this.userId,
      // this.profilePic,
      this.mobileNumber,
      this.gender,
      this.batchname});

  UserProfiles.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    userId = json['UserId'];
    // profilePic = json['ProfilePic'];
    mobileNumber = json['MobileNumber'];
    gender = json['Gender'];
    batchname = json['Batchname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['UserId'] = this.userId;
    // data['ProfilePic'] = this.profilePic;
    data['MobileNumber'] = this.mobileNumber;
    data['Gender'] = this.gender;
    data['Batchname'] = this.batchname;
    return data;
  }
}
