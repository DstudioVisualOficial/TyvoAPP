// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  Driver({
    this.id,
    this.username,
    this.modeloycolor,
    this.cellnumber,
    this.email,
    this.password,
    this.plate,
    this.token,
    this.image,
    this.saldo,
    this.to,        //ESTO NO
    this.from,
    this.role,
    this.toLatLnglatitude,
    this.toLatLnglongitude,
    this.fromLatLnglatitude,
    this.fromLatLnglongitude,
    this.total,
    this.pricepoint,
    this.hora,
    this.min
  });

  String id;
  String username;
  String modeloycolor;
  String cellnumber;
  String email;
  String password;
  String plate;
  String token;
  String image;
  String saldo;
  String to;
  String from;
  String role;
  double toLatLnglatitude;
  double toLatLnglongitude;
  double fromLatLnglatitude;
  double fromLatLnglongitude;
  double total;
  int pricepoint;
  int hora;
  int min;
  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    username: json["username"],
    modeloycolor: json["modeloycolor"],
    cellnumber: json["cellnumber"],
    email: json["email"],
    password: json["password"],
    plate: json["plate"],
    token: json["token"],
    image: json["image"],
    saldo: json["saldo"],
    to: json["to"],
    from: json["from"],
    role : json["role"],
    toLatLnglatitude: json["toLatLnglatitude"],
    toLatLnglongitude: json["toLatLnglongitude"],
    fromLatLnglatitude: json["fromLatLnglatitude"],
    fromLatLnglongitude: json["fromLatLnglongitude"],
    total:  json["total"],
    pricepoint: json["pricepoint"]??0,
    hora: json["hora"],
    min: json["min"],

  );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "username": username,
        "modeloycolor": modeloycolor,
        "cellnumber" : cellnumber,
        "email": email,
        "password": password,
        "plate": plate,
        "token": token,
        "image": image,
        "saldo": saldo,
        "to": to,
        "from": from,
        "role": role,
        "toLatLnglatitude": toLatLnglatitude,
        "toLatLnglongitude": toLatLnglongitude,
        "fromLatLnglatitude": fromLatLnglatitude,
        "fromLatLnglongitude": fromLatLnglongitude,
        "total": total,
        "pricepoint": pricepoint,
        "hora": hora,
        "min":min
      };
}
