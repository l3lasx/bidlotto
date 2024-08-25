// To parse this JSON data, do
//
//     final adminDrawPrizeLottoPoseResponse = adminDrawPrizeLottoPoseResponseFromJson(jsonString);

import 'dart:convert';

AdminDrawPrizeLottoPoseResponse adminDrawPrizeLottoPoseResponseFromJson(String str) => AdminDrawPrizeLottoPoseResponse.fromJson(json.decode(str));

String adminDrawPrizeLottoPoseResponseToJson(AdminDrawPrizeLottoPoseResponse data) => json.encode(data.toJson());

class AdminDrawPrizeLottoPoseResponse {
    String message;
    List<Prize> prizes;

    AdminDrawPrizeLottoPoseResponse({
        required this.message,
        required this.prizes,
    });

    factory AdminDrawPrizeLottoPoseResponse.fromJson(Map<String, dynamic> json) => AdminDrawPrizeLottoPoseResponse(
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
