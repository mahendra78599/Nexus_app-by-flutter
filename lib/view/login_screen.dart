import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final controller = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header with Wave Shape and Logo
            Stack(
              children: [
                Container(
                  height: size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                          : [Colors.blue.shade900, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                ).animate().fade(duration: const Duration(milliseconds: 600)).slideY(begin: -0.2, end: 0),
                
                Positioned(
                  top: size.height * 0.1,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        ),
                        child: const Icon(Icons.fingerprint, size: 90, color: Colors.white)
                            .animate(onPlay: (controller) => controller.repeat())
                            .shimmer(duration: const Duration(seconds: 2), color: Colors.blue.shade200)
                            .shake(hz: 2, curve: Curves.easeInOut),
                      ).animate().scale(delay: const Duration(milliseconds: 400), duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack),
                      
                      const SizedBox(height: 20),
                      
                      const Text(
                        "NEXUS HR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ).animate().fade(delay: const Duration(milliseconds: 600)).slideY(begin: 0.5, end: 0),
                      
                      const Text(
                        "Smart Attendance System",
                        style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1),
                      ).animate().fade(delay: const Duration(milliseconds: 800)),
                    ],
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: -0.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 1000)).slideX(begin: -0.2, end: 0),
                  
                  Text(
                    "Please sign in to continue", 
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 16)
                  ).animate().fade(delay: const Duration(milliseconds: 1100)),
                  
                  const SizedBox(height: 40),
                  
                  // Employee ID Field
                  TextField(
                    controller: controller.employeeIdCtrl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: "Employee ID",
                      hintText: "Enter ID (1-10)",
                      labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.badge_outlined, color: Colors.blue),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 1200)).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  // Password Field
                  TextField(
                    controller: controller.passwordCtrl,
                    obscureText: true,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "••••••••",
                      labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 1300)).slideY(begin: 0.3, end: 0),
                  
                  const SizedBox(height: 10),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?", 
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.blue.shade300 : Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 1400)),
                  
                  const SizedBox(height: 30),
                  
                  // Login Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shadowColor: Colors.blue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SIGN IN",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                    ),
                  )).animate().fade(delay: const Duration(milliseconds: 1500)).scale(curve: Curves.elasticOut),
                  
                  const SizedBox(height: 20),
                  
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                        children: [
                          TextSpan(
                            text: "Contact Admin",
                            style: TextStyle(
                              color: isDark ? Colors.blue.shade300 : Colors.blue.shade800, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(delay: const Duration(milliseconds: 1700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
