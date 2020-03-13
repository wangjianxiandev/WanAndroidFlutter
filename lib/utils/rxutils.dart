import 'dart:async';

import 'package:rxdart/rxdart.dart';

///倒计时 单位s
StreamSubscription countDownTimer(
    int totalCount, Function(int time, bool isFinish) callback) {
  StreamSubscription timerObservable;
  timerObservable =
      Observable.periodic(Duration(seconds: 1), (x) => x).listen((x) {
    if (x + 1 < totalCount) {
      callback(totalCount - x, false);
    } else {
      callback(1, true);
      timerObservable.cancel();
    }
  });
  return timerObservable;
}
