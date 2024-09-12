import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<String> convertToThaiDate(String utcDateString) async {
  await initializeDateFormatting('th_TH', null);
  DateTime utcDate = DateTime.parse(utcDateString);
  DateTime localDate = utcDate.toLocal();
  DateFormat thaiFormatter = DateFormat('d MMMM y', 'th_TH');
  String thaiDate = thaiFormatter.format(localDate);
  int thaiYear = localDate.year + 543;
  thaiDate = thaiDate.replaceFirst(RegExp(r'\d{4}'), thaiYear.toString());
  return thaiDate;
}

class LottoCard extends StatelessWidget {
  final String lottoNumber;
  final VoidCallback onAdded;
  final bool isShowIconCart;
  final String dateLotto;
  final int lottoStatus;
  final int lottoPrice;

  const LottoCard({
    Key? key,
    required this.lottoNumber,
    required this.onAdded,
    this.isShowIconCart = true,
    this.dateLotto = "",
    required this.lottoStatus,
    this.lottoPrice = 0,
  }) : super(key: key);

  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  Widget _buildStatusButton() {
    switch (lottoStatus) {
      case 2:
        return FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
          ),
          onPressed: () {},
          child: const Text('ยังไม่ตรวจ'),
        );
      case 3:
        return FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
          onPressed: () {},
          child: const Text('ถูกรางวัล'),
        );
      case 4:
        return FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
          onPressed: () {},
          child: const Text('ไม่ถูกรางวัล'),
        );
      default:
        return const SizedBox.shrink(); // ไม่แสดงปุ่มสำหรับสถานะอื่น ๆ
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                lottoNumber,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 6,
                ),
              ),
            ),
            if (isShowIconCart)
              Positioned(
                bottom: 0,
                right: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("฿${lottoPrice}",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    GestureDetector(
                      onTap: onAdded,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Align(
                alignment: Alignment.bottomLeft,
                child: FutureBuilder<String>(
                  future: convertToThaiDate(dateLotto),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          _buildStatusButton(),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator(color: Colors.white);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
