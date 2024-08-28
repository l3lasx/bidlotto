// To parse this JSON data, do
//
//     final adminDrawPrizeLottoPostResponse = adminDrawPrizeLottoPostResponseFromJson(jsonString);

import 'dart:convert';

AdminDrawPrizeLottoPostResponse adminDrawPrizeLottoPostResponseFromJson(String str) => AdminDrawPrizeLottoPostResponse.fromJson(json.decode(str));

String adminDrawPrizeLottoPostResponseToJson(AdminDrawPrizeLottoPostResponse data) => json.encode(data.toJson());

class AdminDrawPrizeLottoPostResponse {
    String message;
    List<Prize> prizes;

    AdminDrawPrizeLottoPostResponse({
        required this.message,
        required this.prizes,
    });

    factory AdminDrawPrizeLottoPostResponse.fromJson(Map<String, dynamic> json) => AdminDrawPrizeLottoPostResponse(
        message: json["message"],
        prizes: List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "prizes": List<dynamic>.from(prizes.map((x) => x.toJson())),
    };
}

class Prize {
    String number;
    int rewardPoint;
    int seq;

    Prize({
        required this.number,
        required this.rewardPoint,
        required this.seq,
    });

    factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        number: json["number"],
        rewardPoint: json["rewardPoint"],
        seq: json["seq"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "rewardPoint": rewardPoint,
        "seq": seq,
    };
}
