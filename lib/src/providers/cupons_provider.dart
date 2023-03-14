import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/cupons.dart';

class CuponsProvider{
  CollectionReference _ref;
  CuponsProvider(){
    _ref = FirebaseFirestore.instance.collection("Cupons");
  }


  Future<void> create(Cupons cupons){
    String errorMessage;
    try{
      return _ref.doc(cupons.id).set(cupons.toJson());
    }catch(error){
      errorMessage = error.code;
    }
    if(errorMessage != null){
      return Future.error(errorMessage);
    }

  }
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }
}