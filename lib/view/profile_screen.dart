import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark 
                          ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                          : [Colors.blue.shade900, Colors.blue.shade600],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: isDark ? Colors.white10 : Colors.blue.shade50,
                      child: Icon(Icons.person, size: 80, color: isDark ? Colors.white70 : Colors.blue.shade800),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: const Text(
                    "MY PROFILE",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 70),
            
            if (user != null) ...[
              Text(user.name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              Text(user.department.toUpperCase(), 
                style: TextStyle(color: isDark ? Colors.blue.shade300 : Colors.blue.shade800, fontWeight: FontWeight.w600, letterSpacing: 1, fontSize: 13)),
              
              const SizedBox(height: 30),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    _profileInfoCard(context, Icons.badge_outlined, "Employee ID", "#${user.id}"),
                    const SizedBox(height: 15),
                    _profileInfoCard(context, Icons.email_outlined, "Official Email", user.email),
                    const SizedBox(height: 15),
                    _profileInfoCard(context, Icons.phone_outlined, "Phone Number", user.mobile),
                    const SizedBox(height: 15),
                    _profileInfoCard(context, Icons.location_city_outlined, "Company", user.companyName),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  _actionTile(context, Icons.edit_note, "Edit Bio", Colors.blue),
                  const SizedBox(width: 15),
                  _actionTile(context, Icons.verified_user_outlined, "Documents", Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoCard(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isDark ? Colors.blue.shade300 : Colors.blue.shade800, size: 22),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
