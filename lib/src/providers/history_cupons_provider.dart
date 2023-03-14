import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/models/cupons.dart';
import 'package:uber/src/models/cuponsHistory.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/history.dart';

import 'package:uber/src/providers/auth_provider.dart';


class HistoryCuponsProvider{
  AuthProvider _driverProvider = new AuthProvider();
  Driver _history = new Driver();
  CollectionReference _ref;
  HistoryCuponsProvider(){
    _ref = FirebaseFirestore.instance.collection("CuponsHistory");
  }


  Future<void> create(CuponsHistory history){
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

  Future<QuerySnapshot> getByIdStream(String id) {
    return _ref.where('idclient', isEqualTo: id).get();
  }
}