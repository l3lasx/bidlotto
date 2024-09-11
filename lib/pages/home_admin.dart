import 'package:bidlotto/model/request/admin_draw_lotto_post_req.dart';
import 'package:bidlotto/model/response/admin_lotto_get_res.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api/lotto.dart';
import '../services/api/admin.dart';

class HomeAdmin extends ConsumerStatefulWidget {
  const HomeAdmin({super.key});

  @override
  ConsumerState<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends ConsumerState<HomeAdmin> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
  String selectedLottery = 'ลอตเตอรี่ 100';
  bool showUnsold = true;
  AdminLottoGetResponse? unsoldLottoData;
  AdminLottoGetResponse? soldLottoData;
  bool isGeneratingLotto = false;
  bool hasUnsoldLotto = false;
  bool hasSoldLotto = false;

  @override
  void initState() {
    super.initState();
    fetchAllLottoData();
  }

  Future<void> fetchAllLottoData() async {
    await fetchLottoData(true);  // Fetch unsold lotto
    await fetchLottoData(false); // Fetch sold lotto
  }

  Future<void> fetchLottoData([bool? fetchUnsold]) async {
    try {
      final lottoService = ref.read(lottoServiceProvider);
      final response = await lottoService.getLottoByStatus(fetchUnsold ?? showUnsold ? 0 : 2);
      final fetchedData = AdminLottoGetResponse.fromJson(response);
      
      setState(() {
        if (fetchUnsold ?? showUnsold) {
          unsoldLottoData = fetchedData;
          hasUnsoldLotto = fetchedData.data.isNotEmpty;
        } else {
          soldLottoData = fetchedData;
          hasSoldLotto = fetchedData.data.isNotEmpty;
        }
      });
      
      print('Fetched Lotto Data:');
      print(fetchedData.toJson());
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> showConfirmationDialog() async {
    if (hasUnsoldLotto || hasSoldLotto) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('มีลอตเตอรี่อยู่แล้ว ไม่สามารถสร้างใหม่ได้')),
      );
      return;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการสร้างลอตเตอรี่'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('คุณต้องการสร้างลอตเตอรี่ 100 เลขใช่หรือไม่?'),
                Text('ราคา: 80 บาท'),
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
                generateLotto();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> generateLotto() async {
    if (isGeneratingLotto) return;

    setState(() {
      isGeneratingLotto = true;
    });

    try {
      final adminService = ref.read(adminServiceProvider);
      final request = AdminDrawLottoPostRequest(
        expiredDate: DateTime.now().add(Duration(days: 30)).toIso8601String(),
        count: 100,
        price: 80,
      );
      
      final response = await adminService.generateLotto(request);
      
      if (response != null) {
        print('Generated Lotto Numbers:');
        print(response.numbers);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('สร้างลอตเตอรี่สำเร็จ ${response.numbers.length} เลข')),
        );
        fetchLottoData(); // Refresh the lotto data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถสร้างลอตเตอรี่ได้')),
        );
      }
    } catch (e) {
      print('Error generating lotto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการสร้างลอตเตอรี่')),
      );
    } finally {
      setState(() {
        isGeneratingLotto = false;
      });
    }
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
                      'สุ่มลอตเตอรี่ 100 เลข',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (isGeneratingLotto || hasUnsoldLotto || hasSoldLotto) ? null : showConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (isGeneratingLotto || hasUnsoldLotto || hasSoldLotto) ? Colors.grey : mainColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          isGeneratingLotto ? 'กำลังสร้าง...' : 'Generate',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'ลอตเตอรี่ 100',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!showUnsold) {
                                    setState(() {
                                      showUnsold = true;
                                    });
                                    fetchLottoData();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: showUnsold
                                      ? mainColor
                                      : Colors.grey[300],
                                  foregroundColor: showUnsold
                                      ? Colors.white
                                      : Colors.black,
                                  elevation: showUnsold ? 2 : 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text('ยังไม่จำหน่าย',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (showUnsold) {
                                    setState(() {
                                      showUnsold = false;
                                    });
                                    fetchLottoData();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !showUnsold
                                      ? mainColor
                                      : Colors.grey[300],
                                  foregroundColor: !showUnsold
                                      ? Colors.white
                                      : Colors.black,
                                  elevation: !showUnsold ? 2 : 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text('จำหน่ายแล้ว',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: (showUnsold ? unsoldLottoData : soldLottoData) == null
                  ? Center(
                      child: CircularProgressIndicator(color: mainColor),
                    )
                  : (showUnsold ? unsoldLottoData!.data : soldLottoData!.data).isEmpty
                      ? Center(
                          child: Text(
                            showUnsold
                                ? 'ยังไม่มีลอตเตอรี่พร้อมจำหน่าย'
                                : 'ไม่พบลอตเตอรี่ที่จำหน่ายแล้ว',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: (showUnsold ? unsoldLottoData!.data : soldLottoData!.data).length,
                          itemBuilder: (context, index) {
                            final lotto = (showUnsold ? unsoldLottoData!.data : soldLottoData!.data)[index];
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [darkerColor, mainColor],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      lotto.number,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        letterSpacing: 6,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '฿${lotto.price}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}