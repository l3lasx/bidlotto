// To parse this JSON data, do
//
//     final customerUpdatePutResponse = customerUpdatePutResponseFromJson(jsonString);

import 'dart:convert';

CustomerUpdatePutResponse customerUpdatePutResponseFromJson(String str) => CustomerUpdatePutResponse.fromJson(json.decode(str));

String customerUpdatePutResponseToJson(CustomerUpdatePutResponse data) => json.encode(data.toJson());

class CustomerUpdatePutResponse {
    String message;
    Data data;

    CustomerUpdatePutResponse({
        required this.message,
        required this.data,
    });

    factory CustomerUpdatePutResponse.fromJson(Map<String, dynamic> json) => CustomerUpdatePutResponse(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    int id;
    String email;
    String firstName;
    String lastName;
    String password;
    int role;
    int wallet;

    Data({
        required this.id,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.password,
        required this.role,
        required this.wallet,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        password: json["password"],
        role: json["role"],
        wallet: json["wallet"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "password": password,
        "role": role,
        "wallet": wallet,
    };
}
