import 'package:flutter/material.dart';

class LottoItem extends StatelessWidget {
  final String number;
  final int quantity;
  final double price;
  final VoidCallback onDelete;

  const LottoItem({
    Key? key,
    required this.number,
    required this.quantity,
    required this.price,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$number X $quantity',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '${price.toStringAsFixed(0)} บาท',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete, color: Colors.red, size: 24),
          ),
        ],
      ),
    );
  }
}
