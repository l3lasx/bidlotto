// To parse this JSON data, do
//
//     final lottosGetResponse = lottosGetResponseFromJson(jsonString);

import 'dart:convert';

LottosGetResponse lottosGetResponseFromJson(String str) =>
    LottosGetResponse.fromJson(json.decode(str));

String lottosGetResponseToJson(LottosGetResponse data) =>
    json.encode(data.toJson());

class LottosGetResponse {
  String? message;
  List<Datum>? data;

  LottosGetResponse({
    this.message,
    this.data,
  });

  factory LottosGetResponse.fromJson(Map<String, dynamic> json) =>
      LottosGetResponse(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? number;
  int? price;
  DateTime? expiredDate;
  int? status;

  Datum({
    this.id,
    this.number,
    this.price,
    this.expiredDate,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        number: json["number"],
        price: json["price"],
        expiredDate: json["expired_date"] == null
            ? null
            : DateTime.parse(json["expired_date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "price": price,
        "expired_date": expiredDate?.toIso8601String(),
        "status": status,
      };
}
