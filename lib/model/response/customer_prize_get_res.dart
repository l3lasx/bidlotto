// To parse this JSON data, do
//
//     final customerPrizeGetResponse = customerPrizeGetResponseFromJson(jsonString);

import 'dart:convert';

CustomerPrizeGetResponse customerPrizeGetResponseFromJson(String str) => CustomerPrizeGetResponse.fromJson(json.decode(str));

String customerPrizeGetResponseToJson(CustomerPrizeGetResponse data) => json.encode(data.toJson());

class CustomerPrizeGetResponse {
    String message;
    List<Prize> prizes;

    CustomerPrizeGetResponse({
        required this.message,
        required this.prizes,
    });

    factory CustomerPrizeGetResponse.fromJson(Map<String, dynamic> json) => CustomerPrizeGetResponse(
        message: json["message"],
        prizes: List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "prizes": List<dynamic>.from(prizes.map((x) => x.toJson())),
    };
}

class Prize {
    int dpid;
    String date;
    String number;
    int rewardPoint;
    int seq;

    Prize({
        required this.dpid,
        required this.date,
        required this.number,
        required this.rewardPoint,
        required this.seq,
    });

    factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        dpid: json["dpid"],
        date: json["date"],
        number: json["number"],
        rewardPoint: json["reward_point"],
        seq: json["seq"],
    );

    Map<String, dynamic> toJson() => {
        "dpid": dpid,
        "date": date,
        "number": number,
        "reward_point": rewardPoint,
        "seq": seq,
    };
}
