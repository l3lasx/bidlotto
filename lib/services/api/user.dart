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

  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final path = config['endpoint'] + '/api/users/$id';
      final response = await dio.get(path);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error: User not found');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

final userServiceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return userService(dio);
});
