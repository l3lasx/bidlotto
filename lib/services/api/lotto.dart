import 'dart:convert';

import 'package:bidlotto/config/environment.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class lottoService {
  final Dio dio;

  lottoService(this.dio);

  Future<Map<String, dynamic>> getAllLotto() async {
    try {
      final path = config['endpoint'] + '/api/lotto/';
      final response = await dio.get(path);
      return {
        "statusCode": response.statusCode,
        "data": response.data["data"],
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

  Future<Map<String, dynamic>> searchLotto(String term) async {
    try {
      final path = config['endpoint'] + '/api/lotto/?number=${term}';
      debugPrint(path);
      final response = await dio.get(path);
      return {
        "statusCode": response.statusCode,
        "data": response.data["data"],
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

  Future<Map<String, dynamic>> getAllPrizesReward() async {
    try {
      final path = config['endpoint'] + '/api/lotto/prizes/reward/getall';
      debugPrint(path);
      final response = await dio.get(path);
      return {
        "statusCode": response.statusCode,
        "data": response.data["prizes"],
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

  Future<dynamic> getLottoByStatus(int status) async {
    try {
      final path = '${config['endpoint']}/api/lotto/status/$status';
      final response = await dio.get(path);
      return response.data;
    } catch (e) {
      print('Error fetching lotto by status: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkLotto(lottoNumber) async {
    try {
      debugPrint("$lottoNumber");
      final path = config['endpoint'] + '/api/lotto/check';
      Map<String, dynamic> postData = {"number": lottoNumber};
      var response = await dio.post(
        path,
        data: jsonEncode(postData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return {
        "statusCode": response.statusCode,
        "data": response.data["result"],
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

  Future<Map<String, dynamic>> redeemLotto(lottoNumber) async {
    try {
      debugPrint("$lottoNumber");
      final path = config['endpoint'] + '/api/lotto/redeem';
      Map<String, dynamic> postData = {"number": lottoNumber};
      var response = await dio.post(
        path,
        data: jsonEncode(postData),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return {
        "statusCode": response.statusCode,
        "data": response.data["result"],
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

final lottoServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return lottoService(dio);
});
