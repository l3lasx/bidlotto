import 'dart:convert';

import 'package:bidlotto/config/environment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthorizeService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final path = config['endpoint'] + '/api/auth/login';
      debugPrint('Login path: $path');

      Map<String, dynamic> postData = {"email": email, "password": password};
      var response = await _dio.post(
        path,
        data: jsonEncode(postData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return {
        "statusCode": response.statusCode,
        "data": response.data,
      };
    } catch (e) {
      if (e is DioException) {
        return {
          "statusCode": e.response?.statusCode,
          "data": e.response?.data,
          "error": e.message,
        };
      }
      return {
        "statusCode": 500,
        "error": "An unexpected error occurred",
      };
    }
  }

  Future<Map<String, dynamic>> register(String first_name, String last_name,
      String phone, String password, String password_confirmation) async {
    try {
      final path = config['endpoint'] + '/api/auth/register';
      debugPrint('Login path: $path');
      Map<String, dynamic> postData = {
        "phone": phone,
        "password": password,
        "first_name": first_name,
        "last_name": last_name,
        "password_confirmation": password_confirmation,
      };
      var response = await _dio.post(
        path,
        data: jsonEncode(postData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return {
        "statusCode": response.statusCode,
        "data": response.data,
      };
    } catch (e) {
      if (e is DioException) {
        return {
          "statusCode": e.response?.statusCode,
          "data": e.response?.data,
          "error": e.message,
        };
      }
      return {
        "statusCode": 500,
        "error": "An unexpected error occurred",
      };
    }
  }
}
