import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/TravelHistory.dart';
import 'package:uber/src/providers/driver_provider.dart';

import 'client_provider.dart';

class TravelDriverHistoryProvider {

  CollectionReference _ref;

  TravelDriverHistoryProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelHistory');
  }
  Future<String> create(TravelHistory travelHistory) async {
    String errorMessage;

    try {
      String id = _ref
          .doc()
          .id;
      travelHistory.id = id;

      await _ref.doc(travelHistory.id).set(
          travelHistory.toJson()); // ALMACENAMOS LA INFORMACION
      return id;
    } catch (error) {
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelHistory> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();

    if (document.exists) {
      TravelHistory client = TravelHistory.fromJson(document.data());
      return client;
    }

    return null;
  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }

  Future<List<TravelHistory>> getByIdDrivers(String idDriver) async {
    QuerySnapshot querySnapshot = await _ref.where('idDriver', isEqualTo: idDriver).orderBy('timestamp', descending: true).get();
    List<Map<String, dynamic>> allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List<TravelHistory> travelHistoryList = new List();

    for (Map<String, dynamic> data in allData) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    for (TravelHistory travelHistory in travelHistoryList) {
      ClientProvider clientProvider = new ClientProvider();
      ClientPhone client = await clientProvider.getById(travelHistory.idClient);
      travelHistory.nameDriver = client.username;
    }

    return travelHistoryList;
  }

}