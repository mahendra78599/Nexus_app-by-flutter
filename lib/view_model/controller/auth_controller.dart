import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/data/model/user_model.dart';
import 'package:nexus_app/data/repository/attendance_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final employeeIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final repo = AttendanceRepository();
  
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn.value) {
      // For demo, if logged in, we fetch the first user as the session user
      fetchUserData(1); 
    }
  }

  Future<void> fetchUserData(int id) async {
    isLoading.value = true;
    final users = await repo.getUsers();
    if (users.isNotEmpty) {
      user.value = users.firstWhere((u) => u.id == id, orElse: () => users.first);
    }
    isLoading.value = false;
  }

  Future<void> login() async {
    if (employeeIdCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      Get.snackbar("Required", "Please enter Employee ID and Password", 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1));
      return;
    }

    isLoading.value = true;
    
    // Simulate API call to verify credentials
    // For this demo, we accept '1' to '10' as Employee ID and 'password' as password
    await Future.delayed(const Duration(seconds: 1));
    
    int? userId = int.tryParse(employeeIdCtrl.text);
    if (userId != null && userId >= 1 && userId <= 10 && passwordCtrl.text == "password") {
      final users = await repo.getUsers();
      user.value = users.firstWhere((u) => u.id == userId);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', userId);
      
      isLoggedIn.value = true;
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar("Login Failed", "Invalid credentials. Use ID 1-10 and password 'password'",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1));
    }
    isLoading.value = false;
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
    user.value = null;
    Get.offAllNamed('/login');
  }
}
