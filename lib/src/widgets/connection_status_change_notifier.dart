import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:uber/main.dart';
import 'package:uber/src/utils/check_internet_connection.dart';


class ConnectionStatusChangeNotifier extends ChangeNotifier {
  StreamSubscription _connectionSubscription;

  ConnectionStatus status = ConnectionStatus.online;

  ConnectionStatusChangeNotifier() {
    _connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) {
      status = newStatus;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
