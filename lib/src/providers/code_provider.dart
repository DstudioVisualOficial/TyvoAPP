import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/code.dart';
import 'package:uber/src/models/prices.dart';

class CodeProvider{

  CollectionReference _ref;
  CodeProvider(){
    _ref = FirebaseFirestore.instance.collection('Code');

  }

  Future<Code> getAll() async{
    DocumentSnapshot document = await _ref.doc('info').get();
    Code code = Code.fromJson(document.data());
    return code;
  }
  Future<void> update(Map<String, dynamic> data) {
    return _ref.doc('info').update(data);
  }

}