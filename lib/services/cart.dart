import 'package:bidlotto/config/environment.dart';
import 'package:bidlotto/providers/dioProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class CartState {
  final List<dynamic> items;
  final double totalAmount;

  CartState({this.items = const [], this.totalAmount = 0.0});

  CartState copyWith({List<dynamic>? items, double? totalAmount}) {
    return CartState(
        items: items ?? this.items,
        totalAmount: totalAmount ?? this.totalAmount);
  }
}

class CartService extends StateNotifier<CartState> {
  CartService(this.ref, this.dio) : super(CartState()) {
    loadCart();
  }
  final Dio dio;
  final Ref ref;

  List<dynamic> getCart() {
    return state.items;
  }

  double getTotalAmount() {
    return state.totalAmount;
  }

  Future<void> loadCart() async {
    try {
      final path = config['endpoint'] + '/api/cart/check';
      final response = await dio.get(path);
      final result = {
        "statusCode": response.statusCode,
        "data": response.data,
      };
      final List<dynamic> cartItems = result['data']['items'];
      state = state.copyWith(
          items: cartItems,
          totalAmount: double.parse(result['data']['totalAmount']));
      debugPrint("Cart loaded successfully: $result");
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          debugPrint("Cart is empty");
        } else {
          debugPrint("Error loading cart: ${e.response}");
        }
      } else {
        debugPrint("Unexpected error loading cart: $e");
      }
      state = state.copyWith(items: [], totalAmount: 0);
    }
  }

  Future<Map<String, dynamic>> addToCart(dynamic item) async {
    try {
      final path = config['endpoint'] + '/api/cart/add';
      Map<String, dynamic> postData = {"lotto_id": item['id']};
      var response = await dio.post(
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

  Future<Map<String, dynamic>> removeFromCart(dynamic lotto) async {
    try {
      final path = config['endpoint'] + '/api/cart/remove';
      Map<String, dynamic> postData = {"cid": lotto['cid']};
      var response = await dio.post(
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

  Future<Map<String, dynamic>> buyItemsInCart() async {
    try {
      final path = config['endpoint'] + '/api/cart/buy';
      Map<String, dynamic> postData = {};
      var response = await dio.post(
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

  Future<Map<String, dynamic>> orderMe() async {
    try {
      final path = config['endpoint'] + '/api/cart/order/me';
      final response = await dio.get(path);
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

  Future<void> clearCart() async {
    state = CartState();
    // await _saveCart();
  }

  // Future<void> _saveCart() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('cart', jsonEncode(state.items));
  // }
}

final cartServiceProvider =
    StateNotifierProvider<CartService, CartState>((ref) {
  final dio = ref.watch(dioProvider);
  return CartService(ref, dio);
});
