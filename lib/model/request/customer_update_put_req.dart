// To parse this JSON data, do
//
//     final customerUpdatePutResquest = customerUpdatePutResquestFromJson(jsonString);

import 'dart:convert';

CustomerUpdatePutResquest customerUpdatePutResquestFromJson(String str) => CustomerUpdatePutResquest.fromJson(json.decode(str));

String customerUpdatePutResquestToJson(CustomerUpdatePutResquest data) => json.encode(data.toJson());

class CustomerUpdatePutResquest {
    String firstName;
    String lastName;
    String email;

    CustomerUpdatePutResquest({
        required this.firstName,
        required this.lastName,
        required this.email,
    });

    factory CustomerUpdatePutResquest.fromJson(Map<String, dynamic> json) => CustomerUpdatePutResquest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
    };
}
