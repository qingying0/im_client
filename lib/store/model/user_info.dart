
class UserInfo {
  int id;
  String username;
  String token;
  String avatarUrl;
  String phone;
  String pushId;
  String description;
  int status;

  UserInfo({this.id, this.username, this.token, this.avatarUrl, this.phone,
      this.pushId, this.description, this.status});

  @override
  String toString() {
    return 'UserInfo{id: $id, username: $username, token: $token, avatarUrl: $avatarUrl, phone: $phone, pushId: $pushId, description: $description, status: $status}';
  }


}
