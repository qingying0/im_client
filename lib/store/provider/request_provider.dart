
import 'package:chat/store/model/Request.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;


class RequestProvider with ChangeNotifier {

  List<Request> _listRequest = new List();

  getRequests() {
    return _listRequest;
  }

  updateRequest(int requestId, int status) {
    _listRequest.forEach((item) {
      if(item.id == requestId) {
        item.status = status;
      }
    });
    notifyListeners();
  }

  addRequest(Request request) {
    _listRequest.add(request);
    notifyListeners();
  }

  clear() {
    _listRequest.clear();
    notifyListeners();
  }


}