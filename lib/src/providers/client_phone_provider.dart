import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';

class ClientPhoneProvider{
  CollectionReference _reference;
  ClientPhoneProvider(){
    _reference = FirebaseFirestore.instance.collection('Clients');
  }

  Future<void> create(ClientPhone client){
    String errorMessage;
    try{
      return _reference.doc(client.id).set(client.toJson());
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
  Future<ClientPhone> getById(String id)async{
    DocumentSnapshot documento = await _reference.doc(id).get();
    ClientPhone client;
    if(documento.exists)
      {
         client = ClientPhone.fromJson(documento.data());
         return client ;
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