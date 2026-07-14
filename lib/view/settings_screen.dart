import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';
import 'package:nexus_app/view_model/controller/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("App Preferences"),
          _buildSettingsCard([
            Obx(() => _settingTile(
              Icons.dark_mode_outlined, 
              "Dark Mode", 
              "Switch between light and dark themes",
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
                activeColor: Colors.blue.shade700,
              ),
            )),
            _divider(),
            _settingTile(
              Icons.language_outlined, 
              "Language", 
              "Select your preferred language",
              onTap: () => Get.snackbar("Info", "Multiple languages coming soon"),
            ),
          ]),
          
          const SizedBox(height: 25),
          _sectionTitle("Support"),
          _buildSettingsCard([
            _settingTile(Icons.help_outline, "Help Center", "Get support and FAQ"),
            _divider(),
            _settingTile(Icons.info_outline, "About App", "Version 1.0.0"),
          ]),
          
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(authController),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("LOGOUT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(AuthController controller) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textConfirm: "Yes, Logout",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => controller.logout(),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 5, bottom: 10),
    child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
  );

  Widget _buildSettingsCard(List<Widget> children) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade200)),
    child: Column(children: children),
  );

  Widget _divider() => Divider(height: 1, indent: 55, color: Colors.grey.shade100);

  Widget _settingTile(IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}
