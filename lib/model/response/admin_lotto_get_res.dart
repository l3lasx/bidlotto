// To parse this JSON data, do
//
//     final adminLottoGetResponse = adminLottoGetResponseFromJson(jsonString);

import 'dart:convert';

AdminLottoGetResponse adminLottoGetResponseFromJson(String str) => AdminLottoGetResponse.fromJson(json.decode(str));

String adminLottoGetResponseToJson(AdminLottoGetResponse data) => json.encode(data.toJson());

class AdminLottoGetResponse {
    String message;
    List<Datum> data;

    AdminLottoGetResponse({
        required this.message,
        required this.data,
    });

    factory AdminLottoGetResponse.fromJson(Map<String, dynamic> json) => AdminLottoGetResponse(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String number;
    int price;
    String expiredDate;
    int status;

    Datum({
        required this.id,
        required this.number,
        required this.price,
        required this.expiredDate,
        required this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        number: json["number"],
        price: json["price"],
        expiredDate: json["expired_date"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "price": price,
        "expired_date": expiredDate,
        "status": status,
    };
}
