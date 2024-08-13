// ignore_for_file: unused_element

import 'package:bidlotto/pages/home_user.dart';
import 'package:bidlotto/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bidlotto/utils/getErrorMessage.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirm_passwordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _handleRegister() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final passwordConfirmation = _confirm_passwordController.text;
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (phone.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      showErrorMessage('Please fill in all required fields.', context);
      return;
    }

    if (password != passwordConfirmation) {
      showErrorMessage('Passwords do not match.', context);
      return;
    }

    final response = await ref
        .read(authServiceProvider.notifier)
        .register(firstName, lastName, phone, password, passwordConfirmation);
    if (response['statusCode'] == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeUserPage()),
      );
      showSuccessMessage('Registration successful!', context);
    } else {
      showErrorMessage(getErrorMessage(response), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkerColor, mainColor],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.motorcycle,
                                  color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Bidlotto.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Center(
                                  child: Text(
                                    'สมัครสมาชิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildTextField(
                                    'เบอร์โทรศัพท์', _phoneController),
                                const SizedBox(height: 16),
                                _buildTextField('ชื่อ', _firstNameController),
                                const SizedBox(height: 16),
                                _buildTextField('นามสกุล', _lastNameController),
                                const SizedBox(height: 16),
                                _buildTextField('รหัสผ่าน', _passwordController,
                                    isPassword: true),
                                const SizedBox(height: 16),
                                _buildTextField('ยืนยันรหัสผ่าน',
                                    _confirm_passwordController,
                                    isPassword: true),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  onPressed: () {
                                    _handleRegister();
                                  },
                                  child: const Text(
                                    'สมัครสมาชิก',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController _controller,
      {bool isPassword = false}) {
    return TextField(
      controller: _controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
