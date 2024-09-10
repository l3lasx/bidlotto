import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../model/request/customer_update_put_req.dart';
import '../model/response/customer_update_put_res.dart';
import '../model/userModel.dart';
import '../services/api/user.dart';
import '../services/auth.dart';
import 'package:flutter/services.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final Color mainColor = const Color(0xFFE32321);
  final Color darkerColor = const Color(0xFF7D1312);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  UserModel? userData;
  CustomerUpdatePutResponse? responseUpdate;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _updateTextFields() {
    if (userData != null) {
      _firstNameController.text = userData!.firstName ?? '';
      _lastNameController.text = userData!.lastName ?? '';
      _phoneController.text = userData!.phone ?? '';
      _oldPasswordController.text = '';
      _newPasswordController.text = '';
      _confirmPasswordController.text = '';
    }
  }

  Future<void> _fetchUserData() async {
    final authstate = ref.read(authServiceProvider);
    final user = authstate.user;
    if (user != null && user.id != null) {
      final apiService = ref.read(userServiceProvider);
      try {
        final data = await apiService.getUserById(user.id!);
        if (data != null && data['data'] != null) {
          setState(() {
            userData = UserModel.fromJson(data['data']);
            _updateTextFields();
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  void _showConfirmationDialog() {
    if (_phoneController.text.length != 10) {
      _showErrorDialog('กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ต้องการอัพเดทหรือไม่'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ตกลง', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _updateUserData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserData() async {
    final authstate = ref.read(authServiceProvider);
    final user = authstate.user;
    if (user != null && user.id != null) {
      if (_phoneController.text.length != 10) {
        _showErrorDialog('กรุณากรอกเบอร์โทรศัพท์ให้ครบ 10 หลัก');
        return;
      }

      final apiService = ref.read(userServiceProvider);
      try {
        final updateData = CustomerUpdatePutResquest(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
        );

        final response = await apiService.updateUser(user.id!, updateData);
        responseUpdate = CustomerUpdatePutResponse.fromJson(response!);
        if (responseUpdate != null) {
          _showSuccessDialog();
          await _fetchUserData();
        } else {
          _showErrorDialog('Failed to update user data');
        }
      } catch (e) {
        print('Error updating user data: $e');
        _showErrorDialog('An error occurred while updating user data');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    final authstate = ref.read(authServiceProvider.notifier);
    authstate.logout();
    // หลังจาก logout สำเร็จ ให้นำทางไปยังหน้า login
    context.push('/login');
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('สำเร็จ'),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
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
        leading: context.canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => {
                  if (context.canPop())
                    {context.pop()}
                  else
                    {GoRouter.of(context).go('/home')}
                },
              )
            : null,
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
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
                        'ข้อมูลส่วนตัว',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
            Positioned(
              top: 120,
              left: 8,
              right: 8,
              child: Card(
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
                        'อัพเดทข้อมูลส่วนตัว',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'นามสกุล',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'เบอร์โทรศัพท์',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'อัพเดทข้อมูลส่วนตัว',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 8,
              right: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'ออกจากระบบ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
