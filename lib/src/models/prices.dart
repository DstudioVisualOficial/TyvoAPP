import 'dart:convert';

Prices pricesFromJson(String str) => Prices.fromJson(json.decode(str));

String pricesToJson(Prices data) => json.encode(data.toJson());

class Prices {
  Prices({
    this.km,
    this.min,
    this.minValue,
    this.base,
  });

  double km;
  double min;
  double minValue;
  double base;
  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
    km: json["km"].toDouble(),
    min: json["min"].toDouble(),
    minValue: json["minValue"].toDouble(),
    base: json["base"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "km": km,
    "min": min,
    "minValue": minValue,
    "base":base
  };
}
