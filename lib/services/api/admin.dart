import 'dart:convert';

import 'package:bidlotto/model/request/admin_draw_lotto_post_req.dart';
import 'package:bidlotto/model/request/admin_draw_prize_lotto_req.dart';
import 'package:bidlotto/model/response/admin_draw_lotto_post_res_.dart';
import 'package:bidlotto/model/response/admin_draw_prize_lotto_post.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/environment.dart';

class adminService {
  final Dio dio;

  adminService(this.dio);

  Future<Map<String, dynamic>?> resetTables() async {
    try {
      final path = config['endpoint'] + '/api/admin/reset';
      final response = await dio.post(path);
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error: Failed to reset tables');
        return null;
      }
    } catch (e) {
      print('Error resetting tables: $e');
      return null;
    }
  }

  Future<AdminDrawPrizeLottoPostResponse?> drawRandomFromLottos(AdminDrawPrizeLottoPostRequest request) async {
    try {
      final path = config['endpoint'] + '/api/admin/draw_random_from_lottos';
      final response = await dio.post(
        path,
        data: adminDrawPrizeLottoPostRequestToJson(request),
      );
      
      if (response.statusCode == 200) {
        return adminDrawPrizeLottoPostResponseFromJson(json.encode(response.data));
      } else {
        print('Error: Failed to draw random from lottos');
        return null;
      }
    } catch (e) {
      print('Error drawing random from lottos: $e');
      return null;
    }
  }
  
  Future<AdminDrawPrizeLottoPostResponse?> drawRandomFromSoldLottos(AdminDrawPrizeLottoPostRequest request) async {
    try {
      final path = config['endpoint'] + '/api/admin/draw_random_from_lottos_sell';
      final response = await dio.post(
        path,
        data: adminDrawPrizeLottoPostRequestToJson(request),
      );
      
      if (response.statusCode == 200) {
        return adminDrawPrizeLottoPostResponseFromJson(json.encode(response.data));
      } else {
        print('Error: Failed to draw random from sold lottos');
        return null;
      }
    } catch (e) {
      print('Error drawing random from  lottos: $e');
      return null;
    }
  }

  Future<AdminDrawLottoPostResponse?> generateLotto(AdminDrawLottoPostRequest request) async {
    try {
      final path = config['endpoint'] + '/api/admin/generate_lotto';
      final response = await dio.post(
        path,
        data: adminDrawLottoPostRequestToJson(request),
      );
      
      if (response.statusCode == 200) {
        return adminDrawLottoPostResponseFromJson(json.encode(response.data));
      } else {
        print('Error: Failed to generate lotto');
        return null;
      }
    } catch (e) {
      print('Error generating lotto: $e');
      return null;
    }
  }
}

final adminServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return adminService(dio);
});