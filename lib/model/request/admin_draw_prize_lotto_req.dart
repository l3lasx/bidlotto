// To parse this JSON data, do
//
//     final adminDrawPrizeLottoPostRequest = adminDrawPrizeLottoPostRequestFromJson(jsonString);

import 'dart:convert';

AdminDrawPrizeLottoPostRequest adminDrawPrizeLottoPostRequestFromJson(String str) => AdminDrawPrizeLottoPostRequest.fromJson(json.decode(str));

String adminDrawPrizeLottoPostRequestToJson(AdminDrawPrizeLottoPostRequest data) => json.encode(data.toJson());

class AdminDrawPrizeLottoPostRequest {
    int count;
    List<int> rewardPoints;

    AdminDrawPrizeLottoPostRequest({
        required this.count,
        required this.rewardPoints,
    });

    factory AdminDrawPrizeLottoPostRequest.fromJson(Map<String, dynamic> json) => AdminDrawPrizeLottoPostRequest(
        count: json["count"],
        rewardPoints: List<int>.from(json["rewardPoints"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "rewardPoints": List<dynamic>.from(rewardPoints.map((x) => x)),
    };
}
