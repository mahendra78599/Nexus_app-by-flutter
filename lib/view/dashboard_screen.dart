import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexus_app/view_model/controller/attendance_controller.dart';
import 'package:nexus_app/view_model/controller/auth_controller.dart';
import 'package:nexus_app/view/history_screen.dart';
import 'package:nexus_app/view/profile_screen.dart';
import 'package:nexus_app/view/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DashboardHome(),
    const HistoryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: "History"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final attendanceController = Get.put(AttendanceController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade800, Colors.blue.shade500],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        "Hi, ${authController.user.value?.name ?? 'Employee'}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                      const Text(
                        "Welcome to your work today!",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Time Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Obx(() => Text(attendanceController.currentDate.value, 
                            style: const TextStyle(fontSize: 16, color: Colors.grey))),
                          const SizedBox(height: 10),
                          Obx(() => Text(
                            attendanceController.currentTime.value,
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Status Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          "STATUS", 
                          attendanceController.attendanceStatus, 
                          Icons.info_outline,
                          Colors.blue
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Action Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 65,
                    child: ElevatedButton.icon(
                      onPressed: attendanceController.isLoading.value
                          ? null
                          : () => attendanceController.markAttendance(!attendanceController.isCheckedIn.value),
                      icon: Icon(
                        attendanceController.isCheckedIn.value ? Icons.logout : Icons.login,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: attendanceController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              attendanceController.isCheckedIn.value ? "CHECK OUT" : "CHECK IN",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: attendanceController.isCheckedIn.value ? Colors.red.shade600 : Colors.green.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                  const Text(
                    "* Please ensure you are within office premises",
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, RxString value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                Obx(() => Text(value.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
