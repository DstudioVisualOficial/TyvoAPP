import 'dart:convert';

Cupons cuponsFromJson(String str) => Cupons.fromJson(json.decode(str));

String cuponsToJson(Cupons data) => json.encode(data.toJson());

class Cupons {

  String id;
  String idAdmin;
  String code;
  String descuento;
  String viajes;
  String ciudad;
  String dias;


  Cupons({
    this.id,
    this.idAdmin,
    this.code,
    this.descuento,
    this.viajes,
    this.ciudad,
    this.dias,
  });

  factory Cupons.fromJson(Map<String, dynamic> json) => Cupons(
    id: json["id"],
    idAdmin: json["idAdmin"],
    code: json["code"]??'',
    viajes: json["viajes"]??"",
    descuento: json["descuento"]??"1",
    ciudad: json["ciudad"],
    dias:  json["dias"]??0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idAdmin": idAdmin,
    "code": code,
    "descuento": descuento,
    "viajes": viajes,
    "ciudad": ciudad,
    "dias": dias
  };
}
