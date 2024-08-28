import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final VoidCallback onClose;

  const ResultDialog({
    Key? key,
    required this.isSuccess,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              isSuccess ? 'สำเร็จ' : 'ไม่สำเร็จ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'ตกลง',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onClose();
              },
            ),
          ],
        ),
      ),
    );
  }
}
