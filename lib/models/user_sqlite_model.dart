class Users {
  final id;
  final String? profiles;
  Users({this.id, this.profiles});

  Users.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        profiles = res['profiles'];
  Map<String, Object?> toMap() {
    return {'id': id, 'profiles': profiles};
  }
}
