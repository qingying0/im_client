class GlobalConfig {
  static String ip = "192.168.56.1";
  // static String ip = "127.0.0.1";
  static String port = "9001";
  static String address = ip + ":" + port;
  static String baseUrl = "http://" + address;
  static String wsport = "10083";
  static String wsPath = "ws://" + ip + ":" + wsport + "/ws";
  static bool initFriend = false;
  static bool initSession = false;

  static setInitFriend() {
    initFriend = false;
  }

  static setInitSession() {
    initSession = false;
  }
}
