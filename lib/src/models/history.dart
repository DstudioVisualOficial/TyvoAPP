
import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    this.id,
    this.iddriver,
    this.username,
    this.fecha,
    this.hora,
    this.from,
    this.to,
    this.price,
  });

  String id;
  String iddriver;
  String username;
  String fecha;
  String hora;
  String from;
  String to;
  String price;

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json["id"],
    iddriver: json["iddriver"],
    username: json["username"],
    fecha: json["fecha"],
    hora: json["hora"],
    from: json["from"],
    to: json["to"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "iddriver": iddriver,
    "username": username,
    "fecha": fecha,
    "hora": hora,
    "from": from,
    "to": to,
    "price": price,
  };
}