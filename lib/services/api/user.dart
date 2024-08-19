import 'package:bidlotto/config/environment.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class userService {
  final Dio dio;

  userService(this.dio);

  Future<void> getAllUser() async {
    try {
      final path = config['endpoint'] + '/api/users';
      final response = await dio.get(path);
      print(response.data);
    } catch (e) {
      print('Error: $e');
    }
  }
}

final userServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return userService(dio);
});
