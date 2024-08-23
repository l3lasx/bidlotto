import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartState {
  final List<dynamic> items;

  CartState({this.items = const []});

  CartState copyWith({List<dynamic>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartService extends StateNotifier<CartState> {
  CartService() : super(CartState()) {
    loadCart();
  }

  List<dynamic> getCart() {
    return state.items;
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString('cart');
    if (cartJson != null) {
      final List<dynamic> cartItems = jsonDecode(cartJson);
      state = state.copyWith(items: cartItems);
    }
  }

  Future<void> addToCart(dynamic item) async {
    final updatedItems = [...state.items, item];
    state = state.copyWith(items: updatedItems);
    await _saveCart();
  }

  Future<void> removeFromCart(dynamic item) async {
    final updatedItems = state.items.where((i) => i != item).toList();
    state = state.copyWith(items: updatedItems);
    await _saveCart();
  }

  Future<void> clearCart() async {
    state = CartState();
    await _saveCart();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(state.items));
  }
}

final cartServiceProvider =
    StateNotifierProvider<CartService, CartState>((ref) {
  return CartService();
});
