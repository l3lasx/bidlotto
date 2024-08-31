// To parse this JSON data, do
//
//     final adminDrawLottoPostRequest = adminDrawLottoPostRequestFromJson(jsonString);

import 'dart:convert';

AdminDrawLottoPostRequest adminDrawLottoPostRequestFromJson(String str) => AdminDrawLottoPostRequest.fromJson(json.decode(str));

String adminDrawLottoPostRequestToJson(AdminDrawLottoPostRequest data) => json.encode(data.toJson());

class AdminDrawLottoPostRequest {
    String expiredDate;
    int count;
    int price;

    AdminDrawLottoPostRequest({
        required this.expiredDate,
        required this.count,
        required this.price,
    });

    factory AdminDrawLottoPostRequest.fromJson(Map<String, dynamic> json) => AdminDrawLottoPostRequest(
        expiredDate: json["expired_date"],
        count: json["count"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "expired_date": expiredDate,
        "count": count,
        "price": price,
    };
}
