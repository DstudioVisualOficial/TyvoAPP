import 'package:flutter/material.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/travel_driver_history_provider.dart';
import 'package:uber/src/providers/travel_history_provider.dart';
import 'package:uber/src/models/TravelHistory.dart';

class DriverHistoryController {

  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelDriverHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelDriverHistoryProvider();
    _authProvider = new AuthProvider();

    refresh();
  }

  Future<String> getName (String idCliente) async {
    ClientProvider clientProvider = new ClientProvider();
    ClientPhone client = await clientProvider.getById(idCliente);
    return client.username;
  }

  Future<List<TravelHistory>> getAll() async {
    return await _travelHistoryProvider.getByIdDrivers(_authProvider.getUser().uid);

  }

  void goToDetailHistory(String id) {
    Navigator.pushNamed(context, 'driverhistorydetail', arguments: id);
  }

}