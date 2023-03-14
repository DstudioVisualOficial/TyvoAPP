import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/history.dart';

import 'package:uber/src/providers/auth_provider.dart';


class HistoryAgendaProvider{
  AuthProvider _driverProvider = new AuthProvider();
  Driver _history = new Driver();
  CollectionReference _ref;
  HistoryAgendaProvider(){
    _ref = FirebaseFirestore.instance.collection("Agenda");
  }


  Future<void> create(TravelHistoryAgenda history){
    String errorMessage;
    try{
      return _ref.doc(history.id).set(history.toJson());
    }catch(error){
      errorMessage = error.code;
    }
    if(errorMessage != null){
      return Future.error(errorMessage);
    }

  }
}