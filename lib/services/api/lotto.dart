import 'dart:convert';

import 'package:bidlotto/config/environment.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response/customer_prize_get_res.dart';

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

  Future<CustomerPrizeGetResponse> getAllPrizesReward() async {
    try {
      final path = config['endpoint'] + '/api/lotto/prizes/reward/getall';
      final response = await dio.get(path);
      return customerPrizeGetResponseFromJson(json.encode(response.data));
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}

final lottoServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return lottoService(dio);
});
