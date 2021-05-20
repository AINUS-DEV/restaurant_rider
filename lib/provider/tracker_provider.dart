import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_rider/data/model/body/TrackBody.dart';
import 'package:restaurant_rider/data/model/response/response_model.dart';

class TrackerProvider extends ChangeNotifier {

  bool _startTrack = false;
  Timer timer;

  bool get startTrack => _startTrack;

  updateTrackStart(bool status) {
    _startTrack = status;
    if (status == false && timer != null) {
      timer.cancel();
    }
    notifyListeners();
  }

  Future<ResponseModel> addTrack({TrackBody trackBody}) async {
     ResponseModel responseModel = ResponseModel(true, 'Successfully start track');
    return responseModel;
  }
}

class MyBackgroundService {
  static StreamSubscription timer;

  static void stop() {
    timer?.cancel();
  }
}
