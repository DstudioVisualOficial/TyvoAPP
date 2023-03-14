// To parse this JSON data, do
//
//     final driver = driverFromJson(jsonString);

import 'dart:convert';

Admin driverFromJson(String str) => Admin.fromJson(json.decode(str));

String driverToJson(Admin data) => json.encode(data.toJson());

class Admin {
  Admin({
    this.id,
    this.username,
    this.email,
    this.password,
  });

  String id;
  String username;
  String email;
  String password;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,

  };
}
