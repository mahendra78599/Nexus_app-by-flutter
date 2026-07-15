import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';
import 'package:nexus_app/view_model/controller/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Preferences", 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: isDark ? Colors.white : Colors.blue.shade900)),
        centerTitle: true,
        backgroundColor: theme.cardColor,
        foregroundColor: isDark ? Colors.white : Colors.blue.shade900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("APP SETTINGS", 
              style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 15),
            
            _settingsCard(context, [
              Obx(() => _settingsTile(
                context,
                Icons.dark_mode_rounded, 
                "Dark Appearance", 
                "Reduce eye strain in low light",
                trailing: Switch.adaptive(
                  value: themeController.isDarkMode.value,
                  onChanged: (v) => themeController.toggleTheme(),
                  activeColor: Colors.blue.shade800,
                ),
              )),
              _divider(context),
              _settingsTile(context, Icons.language_rounded, "App Language", "Choose your native language"),
              _divider(context),
              _settingsTile(context, Icons.notifications_active_rounded, "Push Notifications", "Reminders for check-in/out"),
            ]),
            
            const SizedBox(height: 30),
            Text("SECURITY & PRIVACY", 
              style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 15),
            
            _settingsCard(context, [
              _settingsTile(context, Icons.fingerprint_rounded, "Biometric Lock", "Use FaceID or Fingerprint"),
              _divider(context),
              _settingsTile(context, Icons.security_rounded, "Privacy Policy", "How we manage your data"),
            ]),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context, authController),
                icon: const Icon(Icons.logout_rounded),
                label: const Text("SIGN OUT ACCOUNT", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.red.withOpacity(0.1) : Colors.red.shade50,
                  foregroundColor: Colors.red.shade700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red.withOpacity(0.2)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Center(
              child: Text("Nexus HR v1.0.4", style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController controller) {
    final theme = Theme.of(context);
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            Text("Sign Out?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 10),
            Text("Are you sure you want to exit the session?", style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.logout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Sign Out"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.02), blurRadius: 10)],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(BuildContext context) => Divider(height: 1, indent: 60, color: Theme.of(context).dividerColor.withOpacity(0.1));

  Widget _settingsTile(BuildContext context, IconData icon, String title, String subtitle, {Widget? trailing}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: isDark ? Colors.blue.shade300 : Colors.blue.shade900),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color)),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.textTheme.bodyMedium?.color),
    );
  }
}
