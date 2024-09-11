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
  final Color goldColor = const Color(0xFFFFD700);

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
            darkerColor: darkerColor,
            goldColor: goldColor),
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
    required this.goldColor,
  }) : _prizesFuture = prizesFuture;

  final Future<dynamic> _prizesFuture;
  final Color mainColor;
  final Color darkerColor;
  final Color goldColor;

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
              Center(
                child: Text(
                  'ผลรางวัล',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              if (prizesList.isEmpty)
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
                ...prizesList.map((prize) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: goldColor, width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Color(0xFFFAFAFA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'รางวัลที่ ${prize['seq'] ?? ""}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: mainColor,
                                  ),
                                ),
                                Text(
                                  prize['number'] ?? "",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${prize['reward_point'] ?? ""} บาท',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )).toList(),
            ],
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}
