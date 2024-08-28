// To parse this JSON data, do
//
//     final adminDrawLottoPostResponse = adminDrawLottoPostResponseFromJson(jsonString);

import 'dart:convert';

AdminDrawLottoPostResponse adminDrawLottoPostResponseFromJson(String str) => AdminDrawLottoPostResponse.fromJson(json.decode(str));

String adminDrawLottoPostResponseToJson(AdminDrawLottoPostResponse data) => json.encode(data.toJson());

class AdminDrawLottoPostResponse {
    String message;
    List<String> numbers;

    AdminDrawLottoPostResponse({
        required this.message,
        required this.numbers,
    });

    factory AdminDrawLottoPostResponse.fromJson(Map<String, dynamic> json) => AdminDrawLottoPostResponse(
        message: json["message"],
        numbers: List<String>.from(json["numbers"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "numbers": List<dynamic>.from(numbers.map((x) => x)),
    };
}
