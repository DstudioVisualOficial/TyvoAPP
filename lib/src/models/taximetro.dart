import 'dart:convert';

Taximetro taximetroFromJson(String str) => Taximetro.fromJson(json.decode(str));

String taximetroToJson(Taximetro data) => json.encode(data.toJson());

class Taximetro {
  Taximetro({
    this.id,
    this.iddriver,
    this.username,
    this.fecha,
    this.hora,
    this.nombrecliente,
    this.price,
  });

  String id;
  String iddriver;
  String username;
  String fecha;
  String hora;
  String nombrecliente;
  String price;

  factory Taximetro.fromJson(Map<String, dynamic> json) => Taximetro(
    id: json["id"],
    iddriver: json["iddriver"],
    username: json["username"],
    fecha: json["fecha"],
    hora: json["hora"],
    nombrecliente: json["nombrecliente"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "iddriver": iddriver,
    "username": username,
    "fecha": fecha,
    "hora": hora,
    "nombrecliente": nombrecliente,
    "price": price,
  };
}