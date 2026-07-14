import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view/login_screen.dart';
import 'package:nexus_app/view/dashboard_screen.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController()); // Initialize AuthController globally
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'Employee Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      // Note: In a real app, you'd want to wrap this in an Obx if you expect login state to change on start
      initialRoute: authController.isLoggedIn.value ? '/dashboard' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
      ],
    );
  }
}
