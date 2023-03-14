import 'dart:convert';

TravelHistoryAgenda travelHistoryFromJson(String str) => TravelHistoryAgenda.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistoryAgenda data) => json.encode(data.toJson());

class TravelHistoryAgenda {
  TravelHistoryAgenda({
    this.status,
    this.km,
    this.min,
    this.fecha,
    this.id,
    this.iddriver,
    this.from,
    this.to,
    this.timestamp,
    this.price,
    this.nameDriver,
    this.nameClient,
    this.cellclient,
    this.comentariodes
  });
  String status;
  String km;
  String min;
  String fecha;
  String id;
  String comentariodes;
  String iddriver;
  String from;
  String to;
  String cellclient;
  String nameDriver;
  String nameClient;
  int timestamp;
  double price;


  factory TravelHistoryAgenda.fromJson(Map<String, dynamic> json) => TravelHistoryAgenda(
    status: json["status"],
    km: json["km"],
    min: json["min"],
    fecha: json["fecha"],
    id: json["id"],
    comentariodes: json["comentariodes"],
    cellclient: json["cellclient"],
    iddriver: json["idDriver"],
    from: json["from"],
    to: json["to"],
    nameDriver: json["nameDriver"],
    nameClient: json["nameDriver"],
    timestamp: json["timestamp"],
    price: json["price"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "km":km,
    "min":min,
    "fecha": fecha,
    "id": id,
    "comentariodes": comentariodes,
    "cellclient" : cellclient,
    "iddriver": iddriver,
    "from": from,
    "to": to,
    "nameDriver": nameDriver,
    "nameClient": nameClient,
    "timestamp": timestamp,
    "price": price,
  };
}
