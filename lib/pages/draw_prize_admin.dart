import 'package:bidlotto/model/request/admin_draw_prize_lotto_req.dart';
import 'package:bidlotto/model/response/admin_draw_prize_lotto_post.dart';
import 'package:bidlotto/services/api/admin.dart';
import 'package:bidlotto/services/api/lotto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawPrizeAdmin extends ConsumerStatefulWidget {
  const DrawPrizeAdmin({Key? key}) : super(key: key);

  @override
  ConsumerState<DrawPrizeAdmin> createState() => _DrawPrizeAdminState();
}

class _DrawPrizeAdminState extends ConsumerState<DrawPrizeAdmin> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  final Color goldColor = const Color(0xFFFFD700);
  List<Prize> generatedPrizes = [];
  List<dynamic> allPrizes = [];

  @override
  void initState() {
    super.initState();
    fetchAllPrizes();
  }

  Future<void> fetchAllPrizes() async {
    final lottoService = ref.read(lottoServiceProvider);
    try {
      final result = await lottoService.getAllPrizesReward();
      if (result['statusCode'] == 200) {
        setState(() {
          allPrizes = (result['data'] as List).cast<Map<String, dynamic>>();
          allPrizes.sort((a, b) => (a['seq'] as int? ?? 0).compareTo(b['seq'] as int? ?? 0));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch prizes')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> drawRandomNumbers(int type) async {
    final adminService = ref.read(adminServiceProvider);
    final request = AdminDrawPrizeLottoPostRequest(
      count: 5,
      rewardPoints: [100000, 80000, 60000, 40000, 20000],
    );

    try {
      final result;
      (type == 0)
          ? result = await adminService.drawRandomFromLottos(request)
          : result = await adminService.drawRandomFromSoldLottos(request);

      if (result != null) {
        setState(() {
          generatedPrizes = result.prizes;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to draw random numbers')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool get canGeneratePrizes => allPrizes.isEmpty && generatedPrizes.isEmpty;

  Future<void> showConfirmationDialog(int type) async {
    if (!canGeneratePrizes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('มีรางวัลอยู่แล้ว ไม่สามารถสุ่มใหม่ได้')),
      );
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการสุ่มเลขรางวัล'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณต้องการสุ่มเลขรางวัลหรือไม่?'),
                Text('การดำเนินการนี้จะไม่สามารถยกเลิกได้'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop();
                (type == 0) ? drawRandomNumbers(0) : drawRandomNumbers(1);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
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
                    'ชุดใหญ่ โอนไว ไม่โอนคืน',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สุ่มออกรางวัล 5 รางวัลจากลอตเตอรี่ทั้งหมด',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canGeneratePrizes ? () => showConfirmationDialog(0) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canGeneratePrizes ? mainColor : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('Generate',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'สุ่มออกรางวัล 5 รางวัลจากลอตเตอรี่ที่ขาย',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canGeneratePrizes ? () => showConfirmationDialog(1) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canGeneratePrizes ? mainColor : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text('Generate',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (generatedPrizes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ผลการสุ่ม:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...List.generate(
                            generatedPrizes.length,
                            (index) => Padding(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'รางวัลที่ ${index + 1}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: mainColor,
                                              ),
                                            ),
                                            Text(
                                              generatedPrizes[index].number,
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
                                              '${generatedPrizes[index].rewardPoint} บาท',
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
                            ),
                          ),
                        ],
                      ),
                    if (allPrizes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('รางวัลทั้งหมด:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          ...allPrizes.map((prize) => Padding(
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
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
