import 'dart:convert';

Code codeFromJson(String str) => Code.fromJson(json.decode(str));

String codeToJson(Code data) => json.encode(data.toJson());

class Code {
  Code({
    this.user,
    this.password,
    this.image
  });

  String user;
  String password;
  String image;
  factory Code.fromJson(Map<String, dynamic> json) => Code(
      user: json["user"],
      password: json["password"],
      image: json["image"]
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "password": password,
    "image" : image
  };
}
