import 'dart:convert';

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

ClientPhone clientPhoneFromJson(String str) => ClientPhone.fromJson(json.decode(str));

String clientPhoneToJson(ClientPhone data) => json.encode(data.toJson());

class ClientPhone {
  ClientPhone({
    this.id,
    this.cellnumber,
    this.username,
    this.email,
    this.password,
    this.token,
    this.image,
    this.price,
    this.code,
    this.viajes,
    this.descuento,
    this.fechavencimiento
  });

  String id;
  String cellnumber;
  String username;
  String email;
  String password;
  String token;
  String image;
  String price;
  String code;
  String viajes;
  String descuento;
  Timestamp fechavencimiento;

  factory ClientPhone.fromJson(Map<String, dynamic> json) => ClientPhone(
    id: json["id"],
    cellnumber: json["cellnumber"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    token: json["token"],
    image: json["image"],
    price: json["price"],
    code: json["code"],
    viajes: json["viajes"],
    descuento: json["descuento"],
    fechavencimiento: json['fechavencimiento']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cellnumber": cellnumber,
    "username": username,
    "email": email,
    "password": password,
    "token": token,
    "image": image,
    "price": price,
    "code": code,
    "viajes": viajes,
    "descuento": descuento,
    "fechavencimiento": fechavencimiento
  };
}

