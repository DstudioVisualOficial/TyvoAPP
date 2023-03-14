import 'dart:convert';

CuponsHistory cuponsHistoryFromJson(String str) => CuponsHistory.fromJson(json.decode(str));

String cuponsHistoryToJson(CuponsHistory data) => json.encode(data.toJson());

class CuponsHistory {
  CuponsHistory({
    this.id,
    this.idclient,
    this.code,
    this.descuento,
    this.viajes,
    this.ciudad
  });

  String id;
  String idclient;
  String code;
  String descuento;
  String viajes;
  String ciudad;



  factory CuponsHistory.fromJson(Map<String, dynamic> json) => CuponsHistory(
    id: json["id"],
    idclient: json["idclient"],
    code: json["code"],
    descuento: json["descuento"],
    viajes: json["code"],
    ciudad: json["ciudad"]


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idclient": idclient,
    "code":code,
    "descuento":descuento,
    "viajes":viajes,
    "ciudad" : ciudad
  };
}
