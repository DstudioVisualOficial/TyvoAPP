import 'package:flutter/material.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/TravelHistory.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/travel_driver_history_provider.dart';
import 'package:uber/src/providers/travel_history_provider.dart';


class ClientHistoryDetailController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelDriverHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;

  TravelHistory travelHistory;
  Driver driver;

  String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelDriverHistoryProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    getTravelHistoryInfo();
  }

  void getTravelHistoryInfo() async {
    travelHistory = await  _travelHistoryProvider.getById(idTravelHistory);
    getDriverInfo(travelHistory.idDriver);
  }

  void getDriverInfo(String idDriver) async {
    driver = await _driverProvider.getById(idDriver);
    refresh();
  }

}

