// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatarPicture;
  String? password;
  int? role;
  int? wallet;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatarPicture,
    this.password,
    this.role,
    this.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatarPicture: json["avatar_picture"],
        password: json["password"],
        role: json["role"],
        wallet: json["wallet"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar_picture": avatarPicture,
        "password": password,
        "role": role,
        "wallet": wallet,
      };
}
