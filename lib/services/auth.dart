import 'package:bidlotto/model/userModel.dart';
import 'package:bidlotto/services/api/authorize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final UserModel? user;
  final String? token;

  AuthState({required this.user, required this.token});

  bool get isAuthenticated => user != null && token != null;

  AuthState copyWith({UserModel? user, String? token}) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class AuthService extends StateNotifier<AuthState> {
  AuthService() : super(AuthState(user: null, token: null)) {
    checkAuth();
  }

  AuthorizeService authSrv = AuthorizeService();

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> checkAuth() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('auth_token');
    // if (token != null) {
    //   // In a real app, you would validate the token with your backend here
    //   // and fetch the user data if the token is valid
    //   final user =
    //       UserModel(id: '1', name: 'Test User', email: 'test@example.com');
    //   state = AuthState(user: user, token: token);
    // } else {
    //   state = AuthState(user: null, token: null);
    // }
  }

  Future<dynamic> login(String phone, String password) async {
    final Map<String, dynamic> response = await authSrv.login(phone, password);
    if (response['statusCode'] == 200) {
      final token = response['data']['token'];
      await _saveToken(token);
      final user = UserModel.fromJson(response['data']);
      debugPrint("Login response data: $response['data']");
      state = AuthState(user: user, token: token);
    }
    return response;
  }

  Future<dynamic> register(String first_name, String last_name, String phone,
      String password, String password_confirmation) async {
    final Map<String, dynamic> response = await authSrv.register(
        first_name, last_name, phone, password, password_confirmation);
    if (response['statusCode'] == 200) {
      final token = response['data']['token'];
      await _saveToken(token);
      final user = UserModel.fromJson(response['data']);
      debugPrint("Register response data: $response['data']");
      state = AuthState(user: user, token: token);
    }
    return response;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    state = AuthState(user: null, token: null);
  }
}

final authServiceProvider =
    StateNotifierProvider<AuthService, AuthState>((ref) {
  return AuthService();
});
