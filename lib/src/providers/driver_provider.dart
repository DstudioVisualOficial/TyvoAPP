import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uber/src/models/driver.dart';

class DriverProvider{
  CollectionReference _reference;
  DriverProvider(){
    _reference = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void> create(Driver driver){
    String errorMessage;
    try{
      return _reference.doc(driver.id).set(driver.toJson());
    }
    catch(error)
    {
    errorMessage = error.code;
    }

    if(errorMessage != null ){
      return Future.error(errorMessage);
    }
  }
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _reference.doc(id).snapshots(includeMetadataChanges: true);
  }
  Future<Driver> getById(String id)async{
    DocumentSnapshot documento = await _reference.doc(id).get();
    Driver driver;
    if(documento.exists){
    driver = Driver.fromJson(documento.data());
    return driver;
    }
    else
      {
        return null;
    }

  }
  Future<void> update(Map<String, dynamic> data, String id) {
    return _reference.doc(id).update(data);
  }
}