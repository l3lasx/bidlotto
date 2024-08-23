import 'package:flutter/material.dart';

class LottoCard extends StatelessWidget {
  final String lottoNumber;
  final VoidCallback onAdded;

  const LottoCard({Key? key, required this.lottoNumber, required this.onAdded})
      : super(key: key);
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);
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
                child: Text(lottoNumber,
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, letterSpacing: 6)),
              ),
              Positioned(
                bottom: 0,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    onAdded();
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
