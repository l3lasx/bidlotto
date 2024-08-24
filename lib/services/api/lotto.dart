import 'dart:convert';

import 'package:bidlotto/config/environment.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/response/customer_prize_get_res.dart';

class lottoService {
  final Dio dio;

  lottoService(this.dio);

  Future<void> getAllLotto() async {
    try {
      final path = config['endpoint'] + '/api/lotto/';
      final response = await dio.get(path);
      print(response.data);
    } catch (e) {
      print('Error: $e');
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
}

final lottoServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return lottoService(dio);
});
