import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/providers/auth_provider.dart';


class HistoryAgendaTaximetroProvider{
  AuthProvider _driverProvider = new AuthProvider();
  Driver _history = new Driver();
  CollectionReference _ref;
  HistoryAgendaTaximetroProvider(){
    _ref = FirebaseFirestore.instance.collection("Agenda");
  }


  Future<void> create(TravelHistoryAgenda taximetro){
    String errorMessage;
    try{
      return _ref.doc(taximetro.id).set(taximetro.toJson());
    }catch(error){
      errorMessage = error.code;
    }
    if(errorMessage != null){
      return Future.error(errorMessage);
    }

  }
}