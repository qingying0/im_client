
class Friend {
  int id;
  String username;
  String avatarUrl;
  String description;
  bool sex;
  int status;
  int sessionId;


  Friend({this.id, this.username, this.avatarUrl, this.status, this.description, this.sex});

  @override
  String toString() {
    return 'Friend{id: $id, username: $username, avatarUrl: $avatarUrl, description: $description, sex: $sex, status: $status, sessionId: $sessionId}';
  }

}
