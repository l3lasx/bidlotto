// ignore_for_file: unused_element

import 'package:flutter/material.dart';

String getErrorMessage(Map<String, dynamic> response) {
  if (response['data'] is Map<String, dynamic>) {
    final data = response['data'] as Map<String, dynamic>;
    if (data['errors'] is List && data['errors'].isNotEmpty) {
      return data['errors'][0]['msg'];
    } else if (data['message'] != null) {
      return data['message'];
    }
  }
  return 'An unexpected error occurred';
}

void showErrorMessage(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF000000),
    ),
  );
}

void showSuccessMessage(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}
