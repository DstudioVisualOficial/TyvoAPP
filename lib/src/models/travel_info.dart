import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

TravelInfo travelInfoFromJson(String str) => TravelInfo.fromJson(json.decode(str));

String travelInfoToJson(TravelInfo data) => json.encode(data.toJson());

class TravelInfo {
  TravelInfo({
    this.id,
    this.status,
    this.clientstatus,
    this.idDriver,
    this.from,
    this.to,
    this.idTravelHistory,
    this.fromLat,
    this.fromLng,
    this.toLat,
    this.toLng,
    this.price,
    this.hora,
    this.min,
    this.iHora,
    this.fHora,
    this.type,
    this.nameanimals
  });

  String id;
  String status;
  String clientstatus;
  String idDriver;
  String from;
  String to;
  String idTravelHistory;
  double fromLat;
  double fromLng;
  double toLat;
  double toLng;
  double price;
  double hora;
  double min;
  String iHora;
  String fHora;
  String type;
  String nameanimals;
  factory TravelInfo.fromJson(Map<String, dynamic> json) => TravelInfo(
    id: json["id"],
    status: json["status"],
    clientstatus: json["clientstatus"],
    idDriver: json["idDriver"],
    from: json["from"],
    to: json["to"],
    idTravelHistory: json["idTravelHistory"],
    fromLat: json["fromLat"]?.toDouble() ?? 0,
    fromLng: json["fromLng"]?.toDouble()?? 0,
    toLat: json["toLat"]?.toDouble()?? 0,
    toLng: json["toLng"]?.toDouble()?? 0,
    price: json["price"]?.toDouble()?? 0,
    hora: json["hora"]?.toDouble()?? 0,
    min: json["min"]?.toDouble()?? 0,
    iHora: json["iHora"],
    fHora: json["fHora"],
    type: json['type'],
    nameanimals: json['nameanimals']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "clientstatus": clientstatus,
    "idDriver": idDriver,
    "from": from,
    "to": to,
    "idTravelHistory": idTravelHistory,
    "fromLat": fromLat,
    "fromLng": fromLng,
    "toLat": toLat,
    "toLng": toLng,
    "price": price,
    "hora": hora,
    "min": min,
    "iHora" : iHora,
    "fHora" : fHora,
    "type" : type,
    "nameanimals" : nameanimals
  };
}
