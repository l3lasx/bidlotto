import 'package:bidlotto/services/api/user.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/response/customer_prize_get_res.dart';

final prizesProvider =
    FutureProvider.autoDispose<CustomerPrizeGetResponse>((ref) async {
  return ref.read(lottoServiceProvider).getAllPrizesReward();
});

class HomeUserPage extends ConsumerWidget {
  const HomeUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _HomeUserPageContent();
  }
}

class _HomeUserPageContent extends ConsumerWidget {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  _HomeUserPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.read(userServiceProvider);

    ref.watch(prizesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.motorcycle, color: Colors.white),
                SizedBox(width: 8),
                Text('Bidlotto', style: TextStyle(color: Colors.white)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                context.push('/profile');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [mainColor, darkerColor],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      Text(
                        'บิดก่อนได้เปรียบลอตเตอรี่',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ชุดใหญ่ รับไว ไม่โอนคืน',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
            Positioned(
              top: 120,
              left: 8,
              right: 8,
              child: Card(
                color: Colors.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ref.watch(prizesProvider).when(
                        data: (prizeResponse) {
                          final prizes = prizeResponse.prizes;
                          if (prizes.isEmpty) {
                            return const Text('No data available');
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ผลรางวัล',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [mainColor, darkerColor],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    for (var prize in prizes)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('รางวัลที่ ${prize.seq}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                            Text(prize.number,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                            Text('${prize.rewardPoint} บาท',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
