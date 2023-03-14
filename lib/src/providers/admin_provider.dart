import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/admin.dart';

import 'package:uber/src/models/driver.dart';

class AdminProvider{
  CollectionReference _reference;
  AdminProvider(){
    _reference = FirebaseFirestore.instance.collection('Admins');
  }

  Future<void> create(Admin admin){
    String errorMessage;
    try{
      return _reference.doc(admin.id).set(admin.toJson());
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
  Future<Admin> getById(String id)async{
    DocumentSnapshot documento = await _reference.doc(id).get();
    Admin admin;
    if(documento.exists){
      admin = Admin.fromJson(documento.data());
    return admin;
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