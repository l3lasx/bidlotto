import 'package:bidlotto/services/api/lotto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawPrizeState {
  final bool isPrizeDrawn;
  final List<dynamic> prizes;
  final bool isLoading;
  final String? error;

  DrawPrizeState({
    this.isPrizeDrawn = false,
    this.prizes = const [],
    this.isLoading = false,
    this.error,
  });

  DrawPrizeState copyWith({
    bool? isPrizeDrawn,
    List<dynamic>? prizes,
    bool? isLoading,
    String? error,
  }) {
    return DrawPrizeState(
      isPrizeDrawn: isPrizeDrawn ?? this.isPrizeDrawn,
      prizes: prizes ?? this.prizes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class DrawPrizeNotifier extends StateNotifier<DrawPrizeState> {
  final lottoService _lottoService;

  DrawPrizeNotifier(this._lottoService) : super(DrawPrizeState()) {
    checkPrizeStatus();
  }

  Future<void> checkPrizeStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _lottoService.getAllPrizesReward();
      if (result['statusCode'] == 200) {
        final prizes = result['data'] as List<dynamic>;
        state = state.copyWith(
          isLoading: false,
          prizes: prizes,
          isPrizeDrawn: prizes.isNotEmpty,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch prize data',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred: $e',
      );
    }
  }
}

final drawPrizeProvider =
    StateNotifierProvider<DrawPrizeNotifier, DrawPrizeState>((ref) {
  final lottoService = ref.watch(lottoServiceProvider);
  return DrawPrizeNotifier(lottoService);
});
