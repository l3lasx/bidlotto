import 'package:bidlotto/components/screens/main_screen_template.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeUserPage extends ConsumerStatefulWidget {
  const HomeUserPage({super.key});

  @override
  ConsumerState<HomeUserPage> createState() => _HomeUserPageContent();
}

class _HomeUserPageContent extends ConsumerState<HomeUserPage> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  late Future<dynamic> _prizesFuture;

  @override
  void initState() {
    super.initState();
    _prizesFuture = _fetchPrizes();
  }

  Future<dynamic> _fetchPrizes() async {
    final lottoService = ref.read(lottoServiceProvider);
    return lottoService.getAllPrizesReward();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenTemplate(
        children: Card(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LotteryPrizesFetcher(
            prizesFuture: _prizesFuture,
            mainColor: mainColor,
            darkerColor: darkerColor),
      ),
    ));
  }
}

class LotteryPrizesFetcher extends StatelessWidget {
  const LotteryPrizesFetcher({
    super.key,
    required Future<dynamic> prizesFuture,
    required this.mainColor,
    required this.darkerColor,
  }) : _prizesFuture = prizesFuture;

  final Future<dynamic> _prizesFuture;
  final Color mainColor;
  final Color darkerColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _prizesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('เกิดบางอย่างผิดพลาด'),
          );
        } else if (snapshot.hasData) {
          final prizeResponse = snapshot.data!;
          final prizesList =
              (prizeResponse['data'] as List).cast<Map<String, dynamic>>();
          prizesList.sort((a, b) =>
              (a['seq'] as int? ?? 0).compareTo(b['seq'] as int? ?? 0));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ผลรางวัล',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              if (prizesList.length == 0)
                Center(
                  child: Text(
                    'ยังไม่มีการออกรางวัล',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                )
              else
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
                      for (var prize in prizesList)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('รางวัลที่ ${prize['seq'] ?? ""}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              Text(prize['number'] ?? "",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              Text('${prize['reward_point']} บาท',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
